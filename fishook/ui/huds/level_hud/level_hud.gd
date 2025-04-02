extends CanvasLayer
class_name LevelHUD

@export var collectible: PackedScene = preload("res://level/collectibles/scene/BaseCollectible.tscn")
@export var collectible_animation: String = "Spin"
@export var collectible_amount_template: String = "%d/%d"

@onready var model_holder: Node3D = %ModelHolder
@onready var collectible_label: Label = %CollectibleLabel

@export var timer_template: String = "%02.0f:%02.0f:%02d"
@onready var timer_label: RichTextLabel = %TimerLabel

func _ready():
	var inst: BaseCollectible = collectible.instantiate()
	#must be removed to avoid counting in the level collectibles.
	inst.remove_from_group("Collectible")
	model_holder.add_child(inst)
	inst.animation_player.play(collectible_animation)

func update_collectible(amount: int, _max: int) -> void:
	collectible_label.text = collectible_amount_template % [amount, _max]

func update_timer(current_time: Dictionary) -> void:
	var ms: int = current_time["millisecond"] * 100
	timer_label.text = timer_template % [current_time["minute"], current_time["second"], ms]