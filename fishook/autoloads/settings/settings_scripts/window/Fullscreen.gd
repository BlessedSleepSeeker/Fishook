extends Setting

const WINDOW_MODE = ["WINDOWED", "FULLSCREEN", "BORDERLESS"]
@export var base_value: String = "WINDOWED"


func _ready():
	value = base_value
	default = base_value
	possible_values = WINDOW_MODE


# called when settings.apply_settings() is triggered
func apply():
	match value:
		"WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, false)
		"FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, false)
		"BORDERLESS":
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, true)