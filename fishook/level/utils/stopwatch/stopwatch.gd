extends Node
class_name Stopwatch

@export var start_time: float = 0.0
@export var paused_at_load: bool = false

@export var pause: bool = false
@export var current_time: float = 0.0

@export var unaffected_by_time_scale: bool = true

@export var current_time_string_template: String = "%02.0f:%02.0f:%02d"

func _ready():
	reset()

func _physics_process(delta):
	if not pause:
		tick_time(delta)

func tick_time(delta) -> void:
	if unaffected_by_time_scale:
		current_time += delta / Engine.time_scale
	else:
		current_time += delta

func reset() -> void:
	current_time = start_time
	pause = paused_at_load

func get_current_time_dict() -> Dictionary:
	var time_dict: Dictionary = {}
	time_dict["millisecond"] = current_time - int(current_time) 
	time_dict["second"] = int(current_time) % 60
	time_dict["minute"] = int(current_time / 60)

	return time_dict

func get_current_time_as_string() -> String:
	var dict = get_current_time_dict()
	return current_time_string_template % [dict["minute"], dict["second"], dict["millisecond"] * 100]
