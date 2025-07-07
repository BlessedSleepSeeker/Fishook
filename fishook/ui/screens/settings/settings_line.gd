extends HBoxContainer
class_name SettingLine

var lbl: Label
var checkbox: CheckButton
var slider: Slider
var options: OptionButton
var text: LineEdit
var number: SpinBox

@export var action_assignement_line: PackedScene = preload("res://ui/screens/settings/ActionAssignementLine.tscn")
@export var action_assignement_modal: PackedScene = preload("res://ui/screens/settings/actions_assignement_panel.tscn")

@onready var title_container: Container = %TitleContainer
@onready var setting_name: RichTextLabel = %SettingName
@onready var settings_container: Container = %SettingContainer
@onready var input_plus_button: Button = %InputPlusButton

var setting: Setting = null:
	set(val):
		setting = val
		tear_down()
		build()

func _ready():
	input_plus_button.pressed.connect(add_input_event_to_action)

func _on_mouse_exited():
	match setting.type:
		setting.SETTING_TYPE.BOOLEAN:
			checkbox.release_focus()
		setting.SETTING_TYPE.RANGE:
			slider.release_focus()
		setting.SETTING_TYPE.OPTIONS:
			options.release_focus()
		setting.SETTING_TYPE.TEXT:
			text.release_focus()
		setting.SETTING_TYPE.NUMBER:
			number.release_focus()

func tear_down() -> void:
	if lbl != null:
		lbl.queue_free()
	if checkbox != null:
		checkbox.queue_free()
	if slider != null:
		slider.queue_free()
	if options != null:
		options.queue_free()
	if text != null:
		text.queue_free()
	if number != null:
		number.queue_free()
	for child in settings_container.get_children():
		if child is ActionAssignementLine:
			child.queue_free()


func build() -> void:
	setting_name.text = setting.key
	setting_name.tooltip_text = setting.tooltip
	match setting.type:
		setting.SETTING_TYPE.BOOLEAN:
			build_bool()
		setting.SETTING_TYPE.RANGE:
			build_range()
		setting.SETTING_TYPE.OPTIONS:
			build_options()
		setting.SETTING_TYPE.TEXT:
			build_text()
		setting.SETTING_TYPE.NUMBER:
			build_number()
		setting.SETTING_TYPE.INPUT:
			build_input()


func build_bool() -> void:
	checkbox = CheckButton.new()
	checkbox.toggle_mode = true
	checkbox.set_pressed_no_signal(setting.value)
	checkbox.mouse_exited.connect(_on_mouse_exited)
	settings_container.add_child(checkbox)


func build_range() -> void:
	lbl = Label.new()
	slider = HSlider.new()
	slider.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	slider.value_changed.connect(_on_slider_value_changed)
	slider.mouse_exited.connect(_on_mouse_exited)
	settings_container.add_child(lbl)
	settings_container.add_child(slider)
	slider.tick_count = 5
	slider.ticks_on_borders = true
	slider.min_value = setting.min_value_range
	slider.max_value = setting.max_value_range
	slider.step = setting.step_range
	slider.value = setting.value


func _on_slider_value_changed(value: float) -> void:
	lbl.text = "%03.*f" % [setting.display_floating_precision, value]


func build_options() -> void:
	options = OptionButton.new()
	if setting.possible_values_strings.is_empty():
		for option in setting.possible_values:
			if option is String:
				options.add_item(option)
			elif option is int or option is float:
				options.add_item(String.num(option))
	else:
		for option_string in setting.possible_values_strings:
			options.add_item(option_string)
	var value_index = setting.possible_values.find(setting.value)
	options.select(value_index)
	options.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	options.fit_to_longest_item = false
	options.mouse_exited.connect(_on_mouse_exited)
	settings_container.add_child(options)

func build_text() -> void:
	text = LineEdit.new()
	settings_container.add_child(text)
	text.text = setting.value

func build_number() -> void:
	number = SpinBox.new()
	settings_container.add_child(number)
	number.min_value = setting.min_value_nbr
	number.max_value = setting.max_value_nbr
	number.step = setting.step_nbr
	number.value = setting.value

#region Input
func build_input() -> void:
	input_plus_button.show()
	setting_name.text = tr(setting.name)
	setting_name.tooltip_text = tr(setting.tooltip) % tr(setting.name)
	for action: InputEvent in InputMap.action_get_events(setting.action):
		var inst: ActionAssignementLine = action_assignement_line.instantiate()
		inst.remove.connect(_on_remove_input)
		inst.rebind.connect(_on_rebind_input)
		settings_container.add_child(inst)
		inst.input_event = action

func _on_remove_input(input_event: InputEvent):
	var action_name: String = setting.key.to_lower()
	print_debug("Removing %s : %s" % [action_name, input_event.as_text()])
	InputMap.action_erase_event(action_name, input_event)
	remove_input_line(input_event)

func _on_rebind_input(input_event: InputEvent):
	var window: Window = Window.new()
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	window.size = get_viewport().size / 2
	var input_panel: ActionsAssignementPanel = action_assignement_modal.instantiate()
	window.add_child(input_panel)
	add_child(window)
	input_panel.action_name = setting.key.to_lower()
	input_panel.action_set.connect(update_input.bind(input_event))
	input_panel.action_set.connect(close_window.bind(window))

func update_input(new_input: InputEvent, old_input: InputEvent) -> void:
	var action_name: String = setting.key.to_lower()
	InputMap.action_erase_event(action_name, old_input)
	InputMap.action_add_event(action_name, new_input)

	var line: ActionAssignementLine = get_input_line_by_event(old_input)
	if line:
		line.input_event = new_input
	else:
		push_error("ActionAssignementLine not found : %s" % old_input.as_text())

func close_window(_new_input: InputEvent, window: Window) -> void:
	window.queue_free()

func add_input_event_to_action() -> void:
	var window: Window = Window.new()
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	window.size = get_viewport().size / 2
	var input_panel: ActionsAssignementPanel = action_assignement_modal.instantiate()
	window.add_child(input_panel)
	add_child(window)
	input_panel.action_set.connect(add_input)
	input_panel.action_set.connect(close_window.bind(window))

func add_input(event: InputEvent):
	var action_name: String = setting.key.to_lower()
	InputMap.action_add_event(action_name, event)
	#print(InputMap.action_get_events(action_name))

	tear_down()
	build()


func remove_input_line(input_event: InputEvent):
	get_input_line_by_event(input_event).queue_free()

func get_input_line_by_event(input_event: InputEvent) -> ActionAssignementLine:
	for child in settings_container.get_children():
		if child is ActionAssignementLine:
			if child.input_event == input_event:
				return child
	return null
#endregion


func is_modified() -> bool:
	match setting.type:
		setting.SETTING_TYPE.BOOLEAN:
			return setting.value != checkbox.button_pressed
		setting.SETTING_TYPE.RANGE:
			return setting.value != slider.value
		setting.SETTING_TYPE.OPTIONS:
			return setting.value != setting.possible_values[options.get_selected_id()]
		setting.SETTING_TYPE.TEXT:
			return setting.value != text.text
		setting.SETTING_TYPE.NUMBER:
			return setting.value != number.value
		setting.SETTING_TYPE.INPUT:
			return false
	return true

func save() -> void:
	match setting.type:
		setting.SETTING_TYPE.BOOLEAN:
			setting.value = checkbox.button_pressed
		setting.SETTING_TYPE.RANGE:
			setting.value = slider.value
		setting.SETTING_TYPE.OPTIONS:
			setting.value = setting.possible_values[options.get_selected_id()]
		setting.SETTING_TYPE.TEXT:
			setting.value = text.text
		setting.SETTING_TYPE.NUMBER:
			setting.value = number.value

func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		if setting != null:
			tear_down()
			build()
