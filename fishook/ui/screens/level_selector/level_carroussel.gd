extends HBoxContainer
class_name LevelCarrousel

@export var levels: Array[LevelData] = []:
	set(data):
		levels = data
		carrousel_render.levels = levels
		carrousel_render.build()

@export var level_title_template: String = "[font_size=70]%s[/font_size]"

@onready var level_title_label: RichTextLabel = %MiniLevelTitle

@onready var left_button: TextureButton = %LeftButton
@onready var right_button: TextureButton = %RightButton

@onready var carrousel_render: CarrouselRender = null

var current_level: LevelData = null
var current_level_index: int = -1

signal changed_carrousel_level(level_data: LevelData)

func _ready():
	left_button.pressed.connect(turn_carrousel_left)
	right_button.pressed.connect(turn_carrousel_right)

func _unhandled_input(_event: InputEvent):
	if Input.is_action_just_released("ui_mouse_up"):
		turn_carrousel_left()
	if Input.is_action_just_released("ui_mouse_down"):
		turn_carrousel_right()

func setup_render(_carrousel_render: CarrouselRender) -> void:
	carrousel_render = _carrousel_render

func turn_carrousel_left() -> void:
	current_level_index -= 1
	if current_level_index < 0:
		current_level_index = levels.size() - 1
	set_level(levels[current_level_index])


func turn_carrousel_right() -> void:
	current_level_index += 1
	if current_level_index > levels.size() - 1:
		current_level_index = 0
	set_level(levels[current_level_index])


func set_level(level: LevelData) -> void:
	current_level = level
	changed_carrousel_level.emit(level)
	level_title_label.text = level_title_template % tr(level.name)
	current_level_index = levels.find(level)
	carrousel_render.rotate_for_index(current_level_index)

func pick_random_level():
	pass

func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		if current_level == null:
			return
		level_title_label.text = level_title_template % tr(current_level.name)
