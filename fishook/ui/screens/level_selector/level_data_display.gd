extends MarginContainer
class_name LevelDataDisplay

@export var level_data: LevelData = null:
	set(data):
		level_data = data
		build()

@export var name_template: String = "[wave amp=60.0 freq=3 connected=1]%s[/wave]"
@export var comment_template: String = "%s"
@export var difficulty_star_rich_tag: String = "[img]line-light/star_colored[/img] "
@export var display_name: bool = true

@onready var name_label: WordByWordLabel = %NameLabel
@onready var comment_label: WordByWordLabel = %CommentLabel
@onready var difficulty_label: WordByWordLabel = %DifficultyLabel
@onready var objective_label: WordByWordLabel = %ObjectiveLabel


func build() -> void:
	if display_name:
		name_label.update_text(name_template % tr(level_data.name))
	else:
		name_label.hide()
	comment_label.update_text(comment_template % tr(level_data.comment))
	build_difficulty_label()
	build_objective()

func build_difficulty_label() -> void:
	var difficulty: String = "[font_size=35]%s[/font_size]" % tr("LEVEL_DIFFICULTY")
	for i in range(0, level_data.difficulty):
		difficulty += difficulty_star_rich_tag
	difficulty_label.update_text(difficulty, true, true)

func build_objective() -> void:
	var txt: String = "%s : %s"
	if level_data.type == level_data.LevelType.REACH_THE_END:
		objective_label.update_text(txt % [tr("LEVEL_OBJECTIVE"), tr("LEVEL_REACH_THE_END")])
	if level_data.type == level_data.LevelType.COLLECTATHON:
		objective_label.update_text(txt % [tr("LEVEL_OBJECTIVE"), tr("LEVEL_COLLECT_EVERYTHING")])

func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		if level_data == null:
			return
		build()
