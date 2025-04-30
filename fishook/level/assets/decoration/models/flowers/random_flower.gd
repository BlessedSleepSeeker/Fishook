@tool
extends Node3D
class_name RandomFlower

@export var flower_models: Array[PackedScene] = []

@export_tool_button("Randomize Flower", "Callable") var randomize_flowe = randomize_flower
func randomize_flower() -> void:
	for child in get_children():
		child.queue_free()
	var flower = flower_models.pick_random().instantiate()
	add_child(flower)

func _ready():
	randomize_flower()