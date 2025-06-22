extends WordByWordLabel
class_name PlayerControlLabel

## The opening tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var control_opening_marker: String = "[control]"
## The closing tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var control_closing_marker: String = "[/control]"
## The icons path template. Where we search for the images.
@export var control_path_template: String = "%s/%s"
## The BBCODE img template. What's going to be added.
@export var control_bbcode_template: String = "[img]%s[/img]"

func _ready():
	InputHandler.input_mode_changed.connect(on_input_mode_changed)

func update_dialog(new_text: String, launch_animation: bool = true, use_letter_by_letter: bool = false):
	original_text = new_text
	var text_: String = parse_controls(new_text)
	var parsed_text = parse_text(text_)
	if disable_all_animations:
		self.visible_characters = -1
	else:
		self.visible_characters = 0
	self.text = parsed_text
	if launch_animation:
		display_text(use_letter_by_letter)

func parse_controls(_text: String) -> String:
	var tag_pos = _text.find(control_opening_marker)
	while tag_pos != -1:
		_text = replace_control_tag_at_pos(_text, tag_pos)
		tag_pos = _text.find(control_opening_marker, tag_pos + control_opening_marker.length())
	return _text

func replace_control_tag_at_pos(_text: String, tag_start_pos: int) -> String:
	var tag_end_pos: int = _text.find(control_closing_marker, tag_start_pos)
	if tag_end_pos == -1:
		push_error("Opening Tag %s at position %d is never closed." % [control_opening_marker, tag_start_pos])
		return _text
	var tag_start_offset_pos: int = tag_start_pos + control_opening_marker.length()
	var tag_length: int = tag_end_pos - tag_start_offset_pos
	var tag_data: String = _text.substr(tag_start_offset_pos, tag_length)

	var input_name = get_input_for_action(tag_data)

	var bbcode_txt: String = control_bbcode_template % input_name

	var replace_length = control_opening_marker.length() + tag_length + control_closing_marker.length()
	return _text.replace(_text.substr(tag_start_pos, replace_length), bbcode_txt)

func get_input_for_action(action_name: String) -> String:
	if InputMap.has_action(action_name):
		for input_event: InputEvent in InputMap.action_get_events(action_name):
			if InputHandler.last_input_mode == InputHandler.INPUT_MODE.CONTROLLER && (input_event is InputEventJoypadMotion or input_event is InputEventJoypadButton):
				return InputHandler.convert_event_to_human_readable(input_event)
			if InputHandler.last_input_mode == InputHandler.INPUT_MODE.KEYBOARD && (input_event is InputEventKey or input_event is InputEventMouse):
				return InputHandler.convert_event_to_human_readable(input_event)
	if action_name == "camera":
		if InputHandler.last_input_mode == InputHandler.INPUT_MODE.CONTROLLER:
			return "xbox/right_stick"
		if InputHandler.last_input_mode == InputHandler.INPUT_MODE.KEYBOARD:
			return "keyboard/mouse_simple"
	return ""

func on_input_mode_changed(_new_input_mode: InputHandler.INPUT_MODE) -> void:
	var input_text = parse_controls(original_text)
	input_text = parse_text(input_text)
	self.text = input_text
