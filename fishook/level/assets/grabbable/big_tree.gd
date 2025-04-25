@tool
extends StaticBody3D
class_name BigTree

@export_group("Save Params")
@export var save_folder_path: String = "res://level/assets/grabbable/saved_trees/"
@export var save_filename: String = ""
@export var extension: String = ".tres"

@export_group("Generation Params")
@export var rng_seed: String = ""

@export_subgroup("Trunk Params")
@export var trunk_slices: float = 10
@export var trunk_min_height: float = 10
@export var trunk_max_height: float = 40
@export var trunk_height_percent_lost_per_slice: float = 0.05
@export var trunk_min_width: float = 2
@export var trunk_max_width: float = 4
@export var trunk_deformation_per_slice: float = 0
@export var trunk_radial_segments: int = 8

@export_subgroup("Branches Params")
@export var branch_chance: float = 0.3:
	set(value):
		branch_chance = value
		branch_chance = clampf(branch_chance, 0, 1)
@export var branch_chance_gain_per_slice: float = 0.03
@export var branch_min_height: float = 1
@export var branch_max_height: float = 3
@export var min_branch_amount: int = 10
@export var max_branch_amount: int = 20
@export var min_branch_per_slice: int = 0
@export var max_branch_per_slice: int = 5
@export var min_branch_recursivity: int = 1
@export var max_branch_recursivity: int = 4
@export var branch_recursivity_chance: float = 0.7
@export var branch_radial_segments: int = 8

@onready var trunk_node: Node3D = %Trunk
@onready var branches_node: Node3D = %Branches

## ProcGen with array mesh
# @onready var mesh_instance: MeshInstance3D = %MeshInstance3D
# @onready var array_mesh: ArrayMesh = ArrayMesh.new()
# @onready var surface_array: Array = []
# @onready var verts := PackedVector3Array()
# @onready var uvs := PackedVector2Array()
# @onready var normals := PackedVector3Array()
# @onready var indices := PackedInt32Array()

var trunk_height: float
var trunk_width: float
var trunk_width_lost_per_slice: float


var branch_height: float
var branch_amount: int
var branch_recursivity: int

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var saved_amount: int = 1

func _ready():
	pass

#region Tools Buttons
@export_group("Buttons")
@export_tool_button("Generate Tree", "Callable") var gen_tree = generate_tree
func generate_tree() -> void:
	setup()
	add_trunk()
	finish_model()

@export_tool_button("Save Model", "Callable") var sve_model = save_model
func save_model() -> void:
	#ResourceSaver.save(mesh_instance.mesh, build_filepath(), ResourceSaver.FLAG_COMPRESS)
	saved_amount += 1

func build_filepath() -> String:
	var filename: String = save_filename if save_filename.length() > 0 else str(saved_amount)
	return save_folder_path + filename + extension

#endregion

#region ProcGen

func setup() -> void:
	## Freeing Previous generation
	for child in trunk_node.get_children():
		child.queue_free()
	for child in branches_node.get_children():
		child.queue_free()
	
	## Setting up rng
	rng = RandomNumberGenerator.new()
	if rng_seed != "":
		rng.seed = hash(rng_seed)
	else:
		rng.randomize()

	## Randomizing things
	trunk_height = rng.randf_range(trunk_min_height, trunk_max_height)
	trunk_width = rng.randf_range(trunk_max_width, trunk_min_width)
	
	branch_height = rng.randf_range(branch_min_height, branch_max_height)
	branch_amount = rng.randi_range(min_branch_amount, max_branch_amount)


	# surface_array.clear()
	# surface_array.resize(Mesh.ARRAY_MAX)
	# verts = PackedVector3Array()
	# uvs = PackedVector2Array()
	# normals = PackedVector3Array()
	# indices = PackedInt32Array()

func add_trunk() -> void:
	var previous_mesh: MeshInstance3D = null
	for i in range(1, trunk_slices + 1):
		var cylinder = generate_trunk_slice(i, previous_mesh)

		var mesh_inst: MeshInstance3D = MeshInstance3D.new()
		mesh_inst.mesh = cylinder
		trunk_node.add_child(mesh_inst)
		mesh_inst.position = calculate_trunk_position(previous_mesh)
		previous_mesh = mesh_inst

		for branch_amount in get_branch_amount_on_slice():
			add_branch(mesh_inst)


func generate_trunk_slice(slice_nbr: int, previous_mesh: MeshInstance3D) -> CylinderMesh:
	var cylinder := CylinderMesh.new()

	## Set height
	var slice_base_height: float = trunk_height / trunk_slices

	## reduce height for each slices
	for i in range(1, slice_nbr):
		slice_base_height = slice_base_height * (1 - trunk_height_percent_lost_per_slice)
	cylinder.height = slice_base_height

	## Set radial segments
	cylinder.radial_segments = trunk_radial_segments
	cylinder.bottom_radius = previous_mesh.mesh.top_radius if previous_mesh else trunk_width
	cylinder.top_radius = calculate_trunk_radius(slice_nbr)


	return cylinder

func calculate_trunk_position(previous_mesh: MeshInstance3D) -> Vector3:
	if previous_mesh:
		var endpoint: Vector3 = previous_mesh.position
		endpoint.y += previous_mesh.mesh.height
		return endpoint
	return Vector3.ZERO

func calculate_trunk_radius(slice_nbr: float) -> float:
	return lerp(trunk_width, 0.0, slice_nbr / trunk_slices)

func get_branch_amount_on_slice() -> int:
	var branch_to_gen: int = 0
	for i in range(branch_amount):
		var chance: float = rng.randf()
		if chance >= branch_chance:
			branch_to_gen += 1
	
	## incrementing chance
	branch_chance += branch_chance_gain_per_slice
	## clamping between the minimum and maximum amount of branch per slices
	return clampi(branch_to_gen, min_branch_per_slice, max_branch_per_slice)

func add_branch(trunk_slice: MeshInstance3D) -> void:
	generate_branch(trunk_slice)


func generate_branch(parent: MeshInstance3D) -> void:
	var branch: MeshInstance3D = MeshInstance3D.new()

	var branch_mesh: CylinderMesh = CylinderMesh.new()
	branch_mesh.radial_segments = branch_radial_segments

	branch_mesh.height = calculate_branch_height(parent.mesh)

	parent.add_child(branch)

	branch.rotation = calculate_branch_rotation()
	branch.position = calculate_branch_position()

func calculate_branch_height(parent: CylinderMesh) -> float:
	return parent.height * 0.7

func calculate_branch_rotation() -> Vector3:
	return Vector3.FORWARD

func calculate_branch_position() -> Vector3:
	return Vector3.ZERO


#endregion

func finish_model() -> void:
	pass
	# surface_array[Mesh.ARRAY_VERTEX] = verts
	# #surface_array[Mesh.ARRAY_TEX_UV] = uvs
	# surface_array[Mesh.ARRAY_NORMAL] = normals
	# surface_array[Mesh.ARRAY_INDEX] = indices

	# # No blendshapes, lods, or compression used.
	# array_mesh = ArrayMesh.new()
	# array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	# mesh_instance.mesh = array_mesh