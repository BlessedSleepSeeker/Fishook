extends Control
class_name LevelSelector

@export var levels: Array[LevelData] = []
@export var level_manager_scene_path: String = "res://level/LevelManager.tscn"
@export var main_menu_scene_path: String = "res://ui/screens/main_menu/main_menu.tscn"

@export var autopress_random_button: bool = false
@export var force_random_level: bool = false
@export var forced_random_level_name: String = ""

@export var title_tr_key: String = "LEVEL_SELECTOR_TITLE"
@export var title_template: String = "[font_size=50][wave amp=40.0 freq=5 connected=1]%s[/wave][/font_size]"

@onready var title_label: RichTextLabel = %TitleLabel

@onready var carrousel: LevelCarrousel = %LevelCarroussel
@onready var carrousel_render: CarrouselRender = %CarrouselRender
@onready var data_display: LevelDataDisplay = %LevelDataDisplay

@onready var return_btn: Button = %ReturnButton
@onready var play_btn: Button = %PlayButton
@onready var random_btn: Button = %RandomButton

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

func _ready():
	localize_title()
	return_btn.pressed.connect(_on_return_button_pressed)
	play_btn.pressed.connect(_on_play_button_pressed)
	random_btn.pressed.connect(_on_random_pressed)
	play_btn.grab_focus()
	build()
	if autopress_random_button:
		_on_random_pressed()

func build() -> void:
	carrousel.setup_render(carrousel_render)
	carrousel.levels = levels
	carrousel.changed_carrousel_level.connect(_on_carrousel_level_changed)
	carrousel.set_level(levels[0])

func _on_carrousel_level_changed(level_data: LevelData) -> void:
	data_display.level_data = level_data

func level_picked(level: LevelData) -> void:
	var level_param_dict: Dictionary = {"level_scene_name": level.scene_name}
	transition_by_path.emit(level_manager_scene_path, level_param_dict, true, "transition")

func _on_return_button_pressed() -> void:
	transition_by_path.emit(main_menu_scene_path, {}, false, "transition")

func _on_play_button_pressed() -> void:
	level_picked(carrousel.current_level)

func _on_random_pressed() -> void:
	random_btn.disabled = true
	if force_random_level:
		for level: LevelData in levels:
			if level.scene_name == forced_random_level_name:
				level_picked(level)
	else:
		var level: LevelData = levels.pick_random()
		level_picked(level)

func localize_title() -> void:
	title_label.text = title_template % tr(title_tr_key)

func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		localize_title()
