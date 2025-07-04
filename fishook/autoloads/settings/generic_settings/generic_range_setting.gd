extends Setting
class_name GenericRangeSetting

@export var base_value: float = 0.5

func _ready():
	value = base_value
	default = base_value
