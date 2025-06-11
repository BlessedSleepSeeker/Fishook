extends Control
class_name LevelSelector

@export var levels: Array[LevelData] = []
@export var level_button_scene: PackedScene = preload("res://ui/screens/level_selector/button/LevelSelectButton.tscn")
@export var level_manager_scene_path: String = "res://level/LevelManager.tscn"
@export var main_menu_scene_path: String = "res://ui/screens/main_menu/main_menu.tscn"

@export var force_random_level: bool = false
@export var autopress_random_button = false
@export var forced_random_level_name: String = "Ascencion"

@onready var button_grid: GridContainer = %GridContainer
@onready var random_btn: Button = %Random

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary)

func _ready():
	build()

func build() -> void:
	for level: LevelData in levels:
		var inst: LevelSelectButton = level_button_scene.instantiate()
		button_grid.add_child(inst)
		inst.pressed.connect(level_picked)
		inst.level_data = level
	random_btn.grab_focus()
	if autopress_random_button:
		_on_random_pressed()


func level_picked(level: LevelData) -> void:
	var level_param_dict: Dictionary = {"level_scene_name": level.scene_name}
	transition_by_path.emit(level_manager_scene_path, level_param_dict)

func _on_return_button_pressed():
	transition_by_path.emit(main_menu_scene_path)


func _on_random_pressed():
	random_btn.disabled = true
	if force_random_level:
		for btn in button_grid.get_children():
			if btn is LevelSelectButton && btn.level_data.name == forced_random_level_name:
				btn.on_button_pressed()
	else:
		var btn = button_grid.get_children().pick_random()
		if btn is LevelSelectButton:
			btn.on_button_pressed()
		else:
			_on_random_pressed()