extends Node3D
class_name HookshotLine

#var character: CharacterInstance
# @export var player_pos_path: NodePath
# @export var fishook_pos_path: NodePath

@export var hook_source: Node3D
@export var fishook: Node3D

@export var point_mesh: Mesh = null

@export_range(2, 100, 1) var point_count: int = 80
	# set(value):
	# 	point_count = value
	# 	reset()


var line_parts: Array[MeshInstance3D] = []

var points: Array[Vector3] = []

var direction: Vector3

var mesh_size: float = 1

func _ready():
	#character = owner as CharacterInstance
	calculate_points()
	spawn_parts()

func reset() -> void:
	# calculate_points()
	# free_parts()
	# spawn_parts()
	pass


func calculate_points() -> void:
	points.clear()
	mesh_size = hook_source.global_position.distance_to(fishook.global_position) / point_count
	direction = hook_source.global_position.direction_to(fishook.global_position)
	#var reverse_direction = fishook.global_position.direction_to(hook_source.global_position)
	#var offset: float = mesh_size / 2

	#var line_start_point = hook_source.global_position + (direction * offset)
	#var line_end_point = fishook.global_position + (reverse_direction * offset)

	for i: float in range(point_count):
		var t = i / (point_count - 1.0)
		points.append(lerp(hook_source.global_position, fishook.global_position, t))

func free_parts() -> void:
	for part in line_parts:
		part.queue_free()
	line_parts.clear()

func spawn_parts() -> void:
	for i in range(0, point_count - 1):
		var inst: MeshInstance3D = MeshInstance3D.new()
		add_child(inst)
		inst.mesh = point_mesh
		line_parts.append(inst)
		#inst.look_at(fishook.global_position, Vector3.UP)

func move_parts() -> void:
	if fishook && hook_source:
		calculate_points()
		for i in range(line_parts.size()):
			line_parts[i].global_position = points[i]

func _physics_process(_delta: float):
	move_parts()
