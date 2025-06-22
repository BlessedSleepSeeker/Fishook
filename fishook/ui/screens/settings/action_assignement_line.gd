extends HBoxContainer
class_name ActionAssignementLine

@onready var current_input_lbl: Label = %FakeLabel
@onready var rebind_btn: Button = $RebindButton
@onready var remove_btn: Button = $RemoveButton

@export var controler_input_text_template: String = "%s"

@export var input_event: InputEvent = null:
	set(value):
		input_event = value
		current_input_lbl.text = translate_controler_input_to_text(input_event)

signal rebind(input: InputEvent)
signal remove(input: InputEvent)

func _ready():
	rebind_btn.pressed.connect(_on_rebind_pressed)
	remove_btn.pressed.connect(_on_remove_pressed)

func translate_controler_input_to_text(_input_event: InputEvent) -> String:
	if _input_event.as_text().contains("Joypad"):
		pass
	return _input_event.as_text()


func _on_rebind_pressed():
	rebind.emit(input_event)

func _on_remove_pressed():
	remove.emit(input_event)
