extends Area3D
class_name DialogTriggerBox

@export_multiline var dialog_text: String = ""
@export var fade_dialog_after: float = -1
@export var fade_dialog_on_exit: bool = true
@export var dialog_use_letter_by_letter: bool = false

signal display_dialog(dialog_text: String, fade_dialog_after: float, use_letter_by_letter: bool)
signal hide_dialog(dialog_text: String)

func _ready():
	body_entered.connect(_body_entered)
	if fade_dialog_on_exit:
		body_exited.connect(_body_exited)


func _body_entered(body: Node3D) -> void:
	if body is CharacterInstance:
		
		display_dialog.emit(dialog_text, fade_dialog_after, dialog_use_letter_by_letter)

func _body_exited(body: Node3D) -> void:
	if body is CharacterInstance:
		hide_dialog.emit(dialog_text)
