extends Node
class_name InputSettings

# setting file path
var settings_folder_name := "settings"
var settings_folder_path := "user://%s/" % settings_folder_name
var controls_file_name := "controls.cfg"
var controls_file_path := "%s%s" % [settings_folder_path, controls_file_name]

@onready var user_folder = DirAccess.open("user://")
@onready var input_file = ConfigFile.new()

# custom actions definition var
#var possible_actions: Array = ["forward", "left", "down", "right", "jump", "throw_hook", "reel_in", "reel_out", "bullet_time", "music_prev", "music_next", "ui_debug_toggle"]

@onready var possible_actions: Array[StringName] = InputMap.get_actions().filter(is_user_action)

var camera_sensitivity: float = 0.5

signal input_mode_changed(new_input_mode: INPUT_MODE)

@export var last_input_mode: INPUT_MODE = INPUT_MODE.KEYBOARD
enum INPUT_MODE {
	KEYBOARD,
	CONTROLLER,
}

func _ready():
	var err = input_file.load(controls_file_path)
	if err != OK:
		printerr("Something happened at %s, error code [%d], creating new input settings file..." % [controls_file_path, err])

		var err_create = create_input_file()
		if err_create != OK:
			printerr("Could not load the settings, using default configuration instead")
		return # default action are set in the editor directly, so we do not need to set them if the input file wasn't found, as we are falling back to default.
	load_player_actions_from_file()

#region Inputs

func _unhandled_input(event: InputEvent):
	if (event is InputEventJoypadButton or event is InputEventJoypadMotion) && last_input_mode != INPUT_MODE.CONTROLLER:
		last_input_mode = INPUT_MODE.CONTROLLER
		input_mode_changed.emit(last_input_mode)
	if (event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey) && last_input_mode != INPUT_MODE.KEYBOARD:
		last_input_mode = INPUT_MODE.KEYBOARD
		input_mode_changed.emit(last_input_mode)

func handle_mouse(mode: bool) -> void:
	if last_input_mode == INPUT_MODE.KEYBOARD:
		if mode:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

#endregion


#region Actions
func is_user_action(action: String) -> bool:
	return not action.begins_with("ui_")

## Need to convert string to input_event
func add_action_from_string(action_name: String, action_value: String) -> void:
	var action_value_input: InputEventKey = InputEventKey.new()
	action_value_input.set_keycode(OS.find_keycode_from_string(action_value))
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	if not InputMap.action_has_event(action_name, action_value_input):
		InputMap.action_add_event(action_name, action_value_input)

func add_action_from_event(action_name: String, action_event: InputEvent) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	if not InputMap.action_has_event(action_name, action_event):
		InputMap.action_add_event(action_name, action_event)

func create_player_actions() -> void:
	for action in possible_actions:
		if not get_value("CONTROLS", action):
			set_value("CONTROLS", action, "")
	save_file()

func check_player_actions() -> String:
	for action in possible_actions:
		var act = check_player_action(action)
		if act != "":
			return act
	return ""

func check_player_action(action: String) -> String:
	if InputMap.has_action(action) and InputMap.action_get_events(action).size() > 0:
		return ""
	return action

func print_actions() -> void:
	for act in InputMap.get_actions():
		if not act.begins_with("ui_"):
			print(act)
	print_debug("___________")

func convert_event_to_human_readable(event: InputEvent) -> String:
	var event_name: String = event.as_text()
	if event_name.contains("Joypad"):
		return convert_joypad_input_to_human_readable(event_name)
	else:
		return "keyboard/" + localize_keyboard_input(event).to_lower()

func convert_joypad_input_to_human_readable(event_name: String) -> String:
	if event_name.contains("Left Stick") and event_name.contains("Joypad Motion"):
		return "xbox/left_stick"
	if event_name.contains("Right Stick") and event_name.contains("Joypad Motion"):
		return "xbox/right_stick"
	if event_name.contains("Xbox A"):
		return "xbox/a"
	if event_name.contains("Xbox B"):
		return "xbox/b"
	if event_name.contains("Xbox X"):
		return "xbox/x"
	if event_name.contains("Xbox Y"):
		return "xbox/y"
	if event_name.contains("Button 4"):
		return "xbox/view"
	if event_name.contains("Button 15"):
		return "xbox/share"
	if event_name.contains("Xbox RT"):
		return "xbox/rt"
	if event_name.contains("Xbox LT"):
		return "xbox/lt"
	if event_name.contains("Xbox RB"):
		return "xbox/rb"
	if event_name.contains("Xbox LB"):
		return "xbox/lb"
	if event_name.contains("Xbox Menu"):
		return "xbox/menu"
	if event_name.contains("D-pad Left"):
		return "xbox/dpad_left"
	if event_name.contains("D-pad Right"):
		return "xbox/dpad_right"
	if event_name.contains("D-pad Up"):
		return "xbox/dpad_up"
	if event_name.contains("D-pad Down"):
		return "xbox/dpad_down"
	return ""

func localize_keyboard_input(event: InputEvent):
	if event is InputEventKey:
		return event.as_text().substr(0, event.as_text().find(" "))
	if event is InputEventMouseButton:
		return event.as_text().replace(" ", "_")

#endregion

#region File
func create_input_file() -> int:
	if not DirAccess.open(settings_folder_path):
		user_folder.make_dir(settings_folder_name)
	return save_file()

func load_player_actions_from_file() -> void:
	for action in possible_actions:
		load_player_action_from_file(action)

func load_player_action_from_file(action: String) -> void:
	for inputevent in input_file.get_section_keys(action):
		var action_value = get_value(action, inputevent)
		if action_value:
			pass#add_action_from_string(action, action_value)

func get_value(section: String, setting: String) -> Variant:
	return input_file.get_value(section, setting, false)

func set_value(section: String, setting: String, value: Variant) -> void:
	input_file.set_value(section, setting, value)

func save_actions_to_file() -> void:
	for action_name in InputMap.get_actions():
		if is_user_action(action_name):
			var i := 0
			for event: InputEvent in InputMap.action_get_events(action_name):
				set_value(action_name, str(i), event.as_text())
				i += 1
	save_file()

func save_file() -> int:
	print_debug('Saving player controls file at %s.' % controls_file_path )
	var err = input_file.save(controls_file_path)

	if err != OK:
		printerr("Error code [%d]. Something went wrong saving the player input file at %s." % [err, controls_file_path])
	return err

#endregion
