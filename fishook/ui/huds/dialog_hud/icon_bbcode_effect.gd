@tool
extends RichTextEffect
class_name RichTextIcon

# Syntax: [icon freq=5.0 span=10.0][/ghost]

## The icons path template. Where we search for the images.
@export var icons_path_template: String = "res://ui/characters/actions/tooltip/tooltip_icons/%s.svg"

# Define the tag name.
var bbcode = "icon"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("freq", 5.0)
	var span = char_fx.env.get("span", 10.0)

	var alpha = sin(char_fx.elapsed_time * speed + (char_fx.range.x / span)) * 0.5 + 0.5
	char_fx.color.a = alpha
	return true