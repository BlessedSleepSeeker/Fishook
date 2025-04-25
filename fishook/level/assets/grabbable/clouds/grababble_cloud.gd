@tool
extends Node3D
class_name GrabbableCloud

@export var cloud_mesh: PackedScene = preload("res://level/assets/grabbable/clouds/CloudMesh.glb")

@export_group("Generation Params")
@export var rng_seed: String = ""

@export_subgroup("Base")
@export var base_max_x_amount: int = 17
@export var base_max_z_amount: int = 17
@export var base_chance_to_disapear: float = 0.2

@export_subgroup("Body")
@export var body_min_blob: int = 40
@export var body_max_blob: int = 100

@export_subgroup("Scattering")
@export var min_x_scatter_distance: float = -2
@export var max_x_scatter_distance: float = 2
@export var min_y_scatter_distance: float = 0
@export var max_y_scatter_distance: float = 0.5
@export var min_z_scatter_distance: float = -3
@export var max_z_scatter_distance: float = 3
@export var maximum_scatter_absolute_distance: float = 2

@export_subgroup("Cloudism")
@export var cloudism_on: bool = true
@export var cloudism_curve: Curve = generate_base_curve()

@export_subgroup("Recursivity")
@export var recursivity: int = 0
@export var recursivity_cloud_amount_reduction: int = 2

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var blob_holder: Node3D = %BlobHolder

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	button_click()

#region ProcGen
func setup() -> void:
	## Freeing Previous generation
	for child in blob_holder.get_children():
		child.queue_free()

	## Setting up rng
	rng = RandomNumberGenerator.new()
	if rng_seed != "":
		rng.seed = hash(rng_seed)
	else:
		rng.randomize()

func generate_cloud(parent: Node3D, _recursivity_amount: int) -> void:
	generate_hitbox()
	generate_base(parent)
	generate_body(parent, _recursivity_amount)

func generate_hitbox() -> void:
	var shape: ConvexPolygonShape3D = ConvexPolygonShape3D.new()
	var point_arr: Array[Vector3] = []
	point_arr.append(Vector3(0, 0, max_z_scatter_distance))
	point_arr.append(Vector3(max_x_scatter_distance, 0, max_z_scatter_distance / 2))
	point_arr.append(Vector3(max_x_scatter_distance, 0, min_z_scatter_distance / 2))
	point_arr.append(Vector3(0, 0, min_z_scatter_distance))
	point_arr.append(Vector3(min_x_scatter_distance, 0, min_z_scatter_distance / 2))
	point_arr.append(Vector3(min_x_scatter_distance, 0, max_z_scatter_distance / 2))

	shape.points = point_arr
	# shape.points.append(Vector3(0, 0.1, max_z_scatter_distance))
	# shape.points.append(Vector3(max_x_scatter_distance, 0.1, max_z_scatter_distance / 2))
	# shape.points.append(Vector3(max_x_scatter_distance, 0.1, min_z_scatter_distance / 2))
	# shape.points.append(Vector3(0, 0.1, min_z_scatter_distance))
	# shape.points.append(Vector3(min_x_scatter_distance, 0.1, min_z_scatter_distance / 2))
	# shape.points.append(Vector3(min_x_scatter_distance, 0.1, max_z_scatter_distance / 2))

	collision_shape.shape = shape

func generate_base(parent: Node3D) -> void:
	var x_offset: int = 0
	var x_tile_size: float = (abs(min_x_scatter_distance) + abs(max_x_scatter_distance)) / base_max_x_amount

	var z_offset: int = 0
	var z_tile_size: float = (abs(min_z_scatter_distance) + abs(max_z_scatter_distance)) / base_max_z_amount

	var base_total_amount: int = base_max_x_amount * base_max_z_amount

	for i in range(base_total_amount):
		var pos_x = min_x_scatter_distance + (x_offset * x_tile_size)
		var pos_z = min_z_scatter_distance + (z_offset * z_tile_size)
		var y_scatter: float = rng.randf_range(min_y_scatter_distance, max_y_scatter_distance)

		var dist: float = Vector2(pos_x, pos_z).length()

		if dist <= maximum_scatter_absolute_distance:
			if rng.randf_range(0, 1) > base_chance_to_disapear:
				var instance: Node3D = cloud_mesh.instantiate()
				parent.add_child(instance)
				instance.position.x = pos_x
				instance.position.y = y_scatter
				instance.position.z = pos_z

		x_offset += 1


		if x_offset > base_max_x_amount:
			x_offset = 0
			z_offset += 1

func generate_body(parent: Node3D, _recursivity_amount: int) -> void:
	var blob_amount = rng.randi_range(body_min_blob, body_max_blob)
	for i in range(blob_amount):
		var x_scatter: float = rng.randf_range(min_x_scatter_distance, max_x_scatter_distance)
		var y_scatter: float = rng.randf_range(min_y_scatter_distance, max_y_scatter_distance)
		var z_scatter: float = rng.randf_range(min_z_scatter_distance, max_z_scatter_distance)

		var dist: float = Vector2(x_scatter, z_scatter).length()

		if dist <= maximum_scatter_absolute_distance:
			var instance: Node3D = cloud_mesh.instantiate()
			parent.add_child(instance)
			instance.position.x = x_scatter
			instance.position.y = y_scatter
			instance.position.z = z_scatter
			elevate_cloud_center(instance)


## We want to elevate clouds blobs that are closer to center.
func elevate_cloud_center(instance: Node3D) -> void:
	if instance == null:
		return
	var distance_from_center: float = Vector2(instance.position.x / max_x_scatter_distance, instance.position.z / max_z_scatter_distance).length()
	var added_elevation: float = cloudism_curve.sample(distance_from_center)

	instance.position.y += added_elevation
	#print(distance_from_center, ":", new_y_pos)

func generate_base_curve() -> Curve:
	var curve: Curve = Curve.new()

	curve.add_point(Vector2(0, 1))
	curve.add_point(Vector2(1, 0))

	return curve

#endregion

#region Tools Buttons
@export_group("Buttons")
@export_tool_button("Generate Cloud", "Callable") var gen_cloud = button_click
func button_click() -> void:
	setup()
	generate_cloud(blob_holder, 0)

#endregion