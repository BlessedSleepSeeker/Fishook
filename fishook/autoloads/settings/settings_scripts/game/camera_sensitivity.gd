extends Setting
class_name CameraSensitivitySetting

@export var base_value: float = 0.5

func _ready():
	value = base_value
	default = base_value

func apply():
	InputHandler.camera_sensitivity = value / max_value_range