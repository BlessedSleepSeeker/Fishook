class_name ActionsAssignementPanel
extends PanelContainer

@onready var current_action_lbl: Label = $MC/VB/C1/CurrentActionLabel
@onready var current_input_lbl: ImgRichTextLabel = $MC/VB/C2/CurrentInputLabel
@onready var accept_input_btn: Button = $MC/VB/C3/Ok
@onready var error_lbl: Label = $MC/VB/C4/ErrorLabel

@export var current_input_template: String = "Player %s, please input %s"

@onready var action_name: String = "If you see this_I fucked up":
	set(val):
		action_name = val
		current_action_lbl.text = action_name

var last_input_event = null:
		set(val):
			last_input_event = val
			current_input_lbl.add_text_icons("[img]%s[/img]" % InputHandler.convert_event_to_human_readable(last_input_event))

signal action_set(input_event: InputEvent)

func _ready():
	accept_input_btn.pressed.connect(_on_button_pressed)
	error_lbl.hide()

func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadMotion or event is InputEventJoypadButton:
		last_input_event = event

func _on_button_pressed():
	if last_input_event == null:
		error_lbl.show()
		error_lbl.text = "No input detected"
		return
	#InputHandler.add_action_from_event(action_name, last_input_event)
	action_set.emit(last_input_event)
	queue_free()
