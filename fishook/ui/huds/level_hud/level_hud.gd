extends CanvasLayer
class_name LevelHUD

@export var collectible: PackedScene = preload("res://level/collectibles/scene/BaseCollectible.tscn")
@export var collectible_animation: String = "Spin"
@export var collectible_amount_template: String = "%d/%d"
@export var timer_template: String = "%02.0f:%02.0f:%02d"
@export var speedrun_start_template: String = "[wave amp=50.0 freq=10 connected=1]%s[/wave]"

@onready var model_holder: Node3D = %ModelHolder
@onready var collectible_label: Label = %CollectibleLabel

@onready var timer_container: Control = %TimerContainer
@onready var timer_label: RichTextLabel = %TimerLabel
@onready var top_container: Control = $MarginContainer
@onready var speedrun_start_label: RichTextLabel = %SpeedrunStartLabel
@onready var speedrun_start_player: AudioStreamPlayer = %SpeedrunStartPlayer
@onready var speedrun_ready_player: AudioStreamPlayer = %SpeedrunReadyPlayer

@onready var root: CustomRoot = get_tree().root.get_node("Root")

signal speedrun_animation_finished

func _ready():
	var inst: BaseCollectible = collectible.instantiate()
	#must be removed to avoid counting in the level collectibles.
	inst.remove_from_group("Collectible")
	model_holder.add_child(inst)
	inst.animation_player.play(collectible_animation)
	timer_container.hide()
	speedrun_start_label.hide()

func update_collectible(amount: int, _max: int) -> void:
	collectible_label.text = collectible_amount_template % [amount, _max]

func update_timer(current_time: Dictionary) -> void:
	var ms: int = current_time["millisecond"] * 100
	timer_label.text = timer_template % [current_time["minute"], current_time["second"], ms]

func fade_hud() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(top_container, "modulate:a", 0, 0.3)

func setup_speedrun_mode() -> void:
	timer_container.show()
	speedrun_start_label.show()
	await root.transition_finished
	play_speedrun_animation()


func play_speedrun_animation() -> void:
	var speedrun_delay: float = root.settings.read_setting_value_by_key("SPEEDRUN_MODE_COUNTDOWN_DELAY")
	speedrun_start_label.text = speedrun_start_template % "3"
	speedrun_start_player.play()
	await get_tree().create_timer(speedrun_delay).timeout

	speedrun_start_label.text = speedrun_start_template % "2"
	speedrun_start_player.play()
	await get_tree().create_timer(speedrun_delay).timeout

	speedrun_start_label.text = speedrun_start_template % "1"
	speedrun_start_player.play()
	await get_tree().create_timer(speedrun_delay).timeout

	speedrun_start_label.text = speedrun_start_template % tr("SPEEDRUN_MODE_GO")
	speedrun_ready_player.play()

	speedrun_animation_finished.emit()

	await get_tree().create_timer(1).timeout
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(speedrun_start_label, "modulate:a", 0, 1)