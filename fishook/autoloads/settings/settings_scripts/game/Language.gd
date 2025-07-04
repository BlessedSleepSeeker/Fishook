extends Setting

@export var base_value: String = "Auto"

func _ready():
	value = base_value
	default = base_value

# called when settings.apply_settings() is triggered
func apply():
	LanguageHandler.language = value
	LanguageHandler.apply_translation()
