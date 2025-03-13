extends Camera3D
class_name FollowCamera3D

## The camera is attached to this node.
@export var carrier_path: NodePath
@export var carrier_offset: Vector3 = Vector3()
@onready var carrier: Node3D = get_node(carrier_path)

## The camera will look at the target.
@export var target_path: NodePath
@export var target_offset: Vector3 = Vector3()
@onready var target: Node3D = get_node(target_path)

func _physics_process(delta):
	#self.global_position = carrier.global_position + carrier_offset
	look_at_from_position(carrier.global_position + carrier_offset, target.global_position)
