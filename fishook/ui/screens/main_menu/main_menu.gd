extends Control

@export_file(".tscn") var creditsScenePath: String = "res://ui/screens/credits/credit_scene.tscn"
@export_file(".tscn") var gamePath: String = "res://ui/screens/level_selector/LevelSelector.tscn"
@export_file(".tscn") var settings_screen_path: String = "res://ui/screens/settings/settings_screen.tscn"

@export var autopress_play_button: bool = false

@onready var play_btn: Button = %Play

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	play_btn.grab_focus()
	if autopress_play_button:
		_on_play_button_pressed()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	transition_by_path.emit(creditsScenePath, {}, false, "transition")

func _on_play_button_pressed():
	transition_by_path.emit(gamePath, {}, false, "transition")

func _on_settings_pressed():
	transition_by_path.emit(settings_screen_path, {}, false, "transition")
