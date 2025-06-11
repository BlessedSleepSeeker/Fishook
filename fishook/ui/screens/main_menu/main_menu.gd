extends Control

@export var creditsScenePath: String = "res://ui/screens/credits/credit_scene.tscn"
@export var gamePath: String = "res://ui/screens/level_selector/LevelSelector.tscn"
@export var settings_screen_path: String = "res://ui/screens/settings/settings_screen.tscn"

@export var autopress_play_button: bool = false

@onready var play_btn: Button = %Play

signal transition(new_scene: PackedScene, animation: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	play_btn.grab_focus()
	if autopress_play_button:
		_on_play_button_pressed()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	var creditsScene = load(creditsScenePath)
	transition.emit(creditsScene, "scene_transition")

func _on_play_button_pressed():
	var gameScene = load(gamePath)
	transition.emit(gameScene, "scene_transition")

func _on_settings_pressed():
	var settings_scene = load(settings_screen_path)
	transition.emit(settings_scene, "scene_transition")
