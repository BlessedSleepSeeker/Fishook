extends CanvasLayer
class_name EndLevelScreen

@export var level_name_template: String = "[font_size=100][wave amp=50.0 freq=0.75 connected=1]%s[/wave][/font_size]"
@export var timer_template: String = "[wave amp=50.0 freq=1.5 connected=1][rainbow freq=0.1 sat=0.8 val=0.8 speed=1.0]%s[/rainbow][/wave]"

@export var collectibles_template_simple: String = "Collected %d of %d"
@export var collectibles_template_animated_perfect: String = "[wave amp=60.0 freq=3 connected=1][rainbow freq=0.3 sat=0.8 val=0.8 speed=2.0]%s[/rainbow][/wave]"
@export var collectibles_template_animated_good: String = "[wave amp=50.0 freq=2 connected=1][rainbow freq=0.2 sat=0.7 val=0.7 speed=1.7]%s[/rainbow][/wave]"
@export var collectibles_template_animated_mid: String = "[wave amp=40.0 freq=1.5 connected=1][rainbow freq=0.1 sat=0.6 val=0.6 speed=1.5]%s[/rainbow][/wave]"
@export var collectibles_template_animated_zero: String = "[wave amp=40.0 freq=1.5 connected=1]%s[/wave]"

@onready var collectible_label: RichTextLabel = %LabelCollectibles

@onready var level_name_label: RichTextLabel = %LevelNameLabel
@onready var timer_label: WordByWordLabel = %TimerLabel

@onready var replay_level_btn: Button = %ReplayButton
@onready var level_select_btn: Button = %LevelSelectButton

@onready var top_container: Control = %TopContainer
@onready var timer_particles: GPUParticles2D = %TimerParticleEmitter

@onready var collected_collectibles_3d: CollectedCollectibles = %CollectedCollectibles

var max_collectibles: int = 0
var spawned_collectibles: int = 0

signal replay
signal level_select

func _ready():
	self.hide()
	top_container.modulate.a = 0
	replay_level_btn.pressed.connect(_on_replay_pressed)
	level_select_btn.pressed.connect(_on_level_select_pressed)

func _on_replay_pressed() -> void:
	replay.emit()

func _on_level_select_pressed() -> void:
	level_select.emit()

func setup(meta_data: LevelData, total_collectibles: int) -> void:
	level_name_label.text = level_name_template % meta_data.name
	max_collectibles = total_collectibles
	collectible_label.text = collectibles_template_simple % [0, max_collectibles]
	timer_label.word_progression.connect(_on_word_progress)
	collected_collectibles_3d.spawned_collectible.connect(_on_collectible_spawned)
	collected_collectibles_3d.finished_spawning.connect(_on_collectibles_finished)

func start_recap(data: Dictionary) -> void:
	self.show()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(top_container, "modulate:a", 1, 0.5)
	await tween.finished
	InputHandler.handle_mouse(true)
	animate_data(data)

func animate_data(data: Dictionary):
	replay_level_btn.grab_focus()
	await animate_timer(data["final_time"])
	animate_collectibles(data["collected_amount"])

func animate_timer(final_time: Dictionary) -> void:
	var ms: int = final_time["millisecond"] * 100
	var time_str: String = "Final Time : %02.0f:%02.0f:%02d" % [final_time["minute"], final_time["second"], ms]

	timer_label.update_text(time_str)
	await timer_label.all_text_displayed
	timer_label.text = timer_template % time_str

func animate_collectibles(amount: int) -> void:
	collected_collectibles_3d.collected_amount = amount
	collected_collectibles_3d.animate_collectibles_spawn()


func add_collectible_amount_to_label() -> void:
	var text: String = collectibles_template_simple % [spawned_collectibles, max_collectibles]
	if (float(spawned_collectibles) / float(max_collectibles)) == 1:
		collectible_label.text = collectibles_template_animated_perfect % text
	elif (float(spawned_collectibles) / float(max_collectibles)) >= 0.75:
		collectible_label.text = collectibles_template_animated_good % text
	elif (float(spawned_collectibles) / float(max_collectibles)) >= 0.5:
		collectible_label.text = collectibles_template_animated_mid % text
	else:
		collectible_label.text = collectibles_template_animated_zero % text

func _on_collectible_spawned() -> void:
	spawned_collectibles += 1
	add_collectible_amount_to_label()

func _on_collectibles_finished() -> void:
	add_collectible_amount_to_label()

func _on_word_progress() -> void:
	timer_particles.emitting = true
