extends MarginContainer
class_name LevelDataDisplay

@export var level_data: LevelData = null:
	set(data):
		level_data = data
		build()

@export var comment_template: String = "%s"
@export var difficulty_star_rich_tag: String = "[img]line-light/star[/img] "

@onready var comment_label: WordByWordLabel = %CommentLabel
@onready var difficulty_label: WordByWordLabel = %DifficultyLabel
@onready var speedrun_option: CheckButton = %SpeedrunOption
@onready var play_button: Button = %PlayButton

signal level_chosen(level_data: LevelData, speedrun_mode: bool)

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	play_button.grab_focus()

func build() -> void:
	comment_label.update_text(comment_template % level_data.comment)
	build_difficulty_label()

func build_difficulty_label() -> void:
	var difficulty: String = "[font_size=35]Difficulty[/font_size] "
	for i in range(0, level_data.difficulty):
		difficulty += difficulty_star_rich_tag
	difficulty_label.update_text(difficulty, true, true)

func get_speedrun_state() -> bool:
	return speedrun_option.button_pressed

func _on_play_pressed() -> void:
	level_chosen.emit(level_data, get_speedrun_state())
