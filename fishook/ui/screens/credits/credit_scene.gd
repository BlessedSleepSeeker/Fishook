extends Control

@export_file(".tscn") var mainMenuPath: String = "res://ui/screens/main_menu/main_menu.tscn"

@onready var return_btn: Button = %ReturnButton

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	return_btn.grab_focus()
	pass # Replace with function body.

func _on_button_pressed():
	transition_by_path.emit(mainMenuPath, {}, false, "transition")
