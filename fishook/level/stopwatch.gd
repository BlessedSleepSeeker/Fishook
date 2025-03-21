extends Node
class_name Stopwatch

@export var current_time: float = 0.00

@export var pause: bool = false

func _physics_process(delta):
	if not pause:
		current_time += delta

func get_current_time_dict() -> Dictionary:
	var time_dict: Dictionary = {}
	time_dict["millisecond"] = current_time - int(current_time) 
	time_dict["second"] = int(current_time) % 60
	time_dict["minute"] = int(current_time / 60)

	return time_dict
