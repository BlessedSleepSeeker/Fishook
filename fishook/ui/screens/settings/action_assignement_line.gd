extends HBoxContainer
class_name ActionAssignementLine

@onready var current_input_lbl: ImgRichTextLabel = %FakeLabel
@onready var rebind_btn: Button = $RebindButton
@onready var remove_btn: Button = $RemoveButton

@export var controler_input_text_template: String = "%s"

@export var input_event: InputEvent = null:
	set(value):
		input_event = value
		current_input_lbl.add_text_icons("[img]%s[/img]" % InputHandler.convert_event_to_human_readable(input_event))

var action: String = ""

signal rebind(input: InputEvent, key: int)
signal remove(input: InputEvent)

func _ready():
	rebind_btn.pressed.connect(_on_rebind_pressed)
	remove_btn.pressed.connect(_on_remove_pressed)

func _on_rebind_pressed():
	var i = 0
	for event in InputMap.action_get_events(action):
		if input_event == event:
			break
		i += 1
	rebind.emit(input_event, i)

func _on_remove_pressed():
	remove.emit(input_event)
