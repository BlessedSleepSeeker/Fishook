extends Control
class_name LevelSelector

@export var levels: Array[LevelData] = []
@export var level_button_scene: PackedScene = preload("res://ui/screens/level_selector/button/LevelSelectButton.tscn")
@export var level_manager_scene_path: String = "res://level/LevelManager.tscn"
@export var main_menu_scene_path: String = "res://ui/screens/main_menu/main_menu.tscn"

@export var autopress_random_button: bool = false
@export var force_random_level: bool = false
@export var forced_random_level_name: String = "Ascencion"

@onready var carrousel: LevelCarrousel = %LevelCarroussel
@onready var data_display: LevelDataDisplay = %LevelDataDisplay
@onready var random_btn: Button = %Random

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

func _ready():
	build()

func build() -> void:
	carrousel.levels = levels
	carrousel.changed_carrousel_level.connect(_on_carrousel_level_changed)
	carrousel.set_level(levels[0])
	data_display.level_chosen.connect(level_picked)

func _on_carrousel_level_changed(level_data: LevelData) -> void:
	data_display.level_data = level_data


func level_picked(level: LevelData, speedrun_mode: bool = false) -> void:
	var level_param_dict: Dictionary = {"level_scene_name": level.scene_name, "speedrun_mode": speedrun_mode}
	transition_by_path.emit(level_manager_scene_path, level_param_dict, true, "transition")

func _on_return_button_pressed():
	transition_by_path.emit(main_menu_scene_path, {}, false, "transition")

func _on_random_pressed():
	random_btn.disabled = true
	if force_random_level:
		for level: LevelData in levels:
			if level.name == forced_random_level_name:
				level_picked(level, data_display.get_speedrun_state())
	else:
		var level: LevelData = levels.pick_random()
		level_picked(level, data_display.get_speedrun_state())