extends Node
class_name LevelManager

@export var level_scene_path: String = "res://level/scenes/"
@export var level_scene_name: String = "Level1"
@export var level_scene_extension: String = ".tscn"

@export var settings_ui_scene: PackedScene = preload("res://ui/screens/settings/settings_screen.tscn")
@export var level_selector_path: String = "res://ui/screens/level_selector/LevelSelector.tscn"
@export var main_menu_path: String = "res://ui/screens/main_menu/main_menu.tscn"

@onready var level_holder: Node3D = %LevelHolder
@onready var ui_layer: CanvasLayer = %PauseUILayer
@onready var pause_ui: PauseUI = %PauseUi
@onready var settings_container: MarginContainer = %SettingsContainer
@onready var settings_ui_layer: CanvasLayer = %SettingsUILayer

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary)
signal play_transition(direction: bool, wait_for_tween: bool)

var is_paused: bool = true

func _ready():
	toggle_pause()
	pause_ui.continue_game.connect(toggle_pause)
	pause_ui.go_to_settings.connect(go_to_settings)
	pause_ui.go_to_level_selector.connect(go_to_level_selector)
	pause_ui.go_to_main_menu.connect(go_to_main_menu)
	load_level()

#region Pausing
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && settings_ui_layer.visible == false:
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_holder.process_mode = PROCESS_MODE_DISABLED
		ui_layer.show()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		level_holder.process_mode = PROCESS_MODE_PAUSABLE
		ui_layer.hide()

func go_to_settings() -> void:
	play_transition.emit(true, false)
	settings_ui_layer.show()
	await get_tree().create_timer(0.5).timeout
	var settings: ClientSettingsUI = settings_ui_scene.instantiate()
	settings.going_back.connect(go_back_from_settings)
	settings.transition_on_back = false
	settings_container.add_child(settings)
	play_transition.emit(false, false)

func go_back_from_settings() -> void:
	play_transition.emit(true, false)
	await get_tree().create_timer(0.5).timeout
	settings_ui_layer.hide()
	for child in settings_container.get_children():
		child.queue_free()
	play_transition.emit(false, false)


func go_to_level_selector() -> void:
	transition_by_path.emit(level_selector_path)

func go_to_main_menu() -> void:
	transition_by_path.emit(main_menu_path)

#endregion

#region Level
func flush_level() -> void:
	for child in level_holder.get_children():
		child.queue_free()

## connect to signal like "level_finished" or things like that
func load_level() -> void:
	var level_scene: PackedScene = load(build_level_path())
	var level_instance = level_scene.instantiate()
	level_holder.add_child(level_instance)

func build_level_path() -> String:
	return level_scene_path + level_scene_name + level_scene_extension

#endregion
