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


func build() -> void:
	comment_label.update_text(comment_template % level_data.comment)
	build_difficulty_label()

func build_difficulty_label() -> void:
	var difficulty: String = "[font_size=35]Difficulty[/font_size] "
	for i in range(0, level_data.difficulty):
		difficulty += difficulty_star_rich_tag
	difficulty_label.update_text(difficulty, true, true)
