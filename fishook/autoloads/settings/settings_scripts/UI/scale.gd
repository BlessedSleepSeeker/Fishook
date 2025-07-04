extends Setting

const UI_SCALE: Array[float] = [1.0, 1.25, 1.5]
const VALUE_STRING: Array[String] = ["UI_SCALE_NORMAL", "UI_SCALE_BIG", "UI_SCALE_BIGGER"]
var base_value: Variant = 1

func _ready():
	value = base_value
	default = base_value
	possible_values = UI_SCALE
	possible_values_strings = VALUE_STRING

## Called when settings.apply_settings() is triggered
func apply():
	get_tree().root.content_scale_factor = value
