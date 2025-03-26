@tool
extends PhysicsBody3D
class_name HookshotLinePart

@export_range(0.01, 100, 0.1) var size: float = 1
	# set(value):
	# 	size = value
	# 	update_size(value)

@onready var mesh_instance: MeshInstance3D = %MeshInstance3D
@onready var start: Marker3D = %Start
@onready var end: Marker3D = %End
@onready var offset: Node3D = %Offset

func update_size(new_size: float):
	mesh_instance.mesh.height = new_size
	offset.position.z = new_size / 2
	start.position.z = new_size / 2
	end.position.z = -new_size / 2
