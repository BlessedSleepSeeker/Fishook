extends Node
class_name InputModule

@export var actor_path: NodePath
@onready var actor: Node = get_node(actor_path)

@export var buffering_window: int = 0

var buffer: Array[InputEvent] = []

func send_input(event: InputEvent):
	pass

func _physics_process(delta):
	pass

func _unhandled_input(event: InputEvent):
	pass#buffer.append(event)