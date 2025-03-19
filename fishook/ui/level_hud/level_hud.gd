extends CanvasLayer
class_name LevelHUD

@export var collectible: PackedScene = preload("res://level/collectibles/scene/BaseCollectible.tscn")
@export var collectible_animation: String = "Spin"
@export var collectible_amount_template: String = "x%d"

@onready var model_holder: Node3D = %ModelHolder
@onready var collectible_label: Label = %CollectibleLabel

func _ready():
	var inst: BaseCollectible = collectible.instantiate()
	model_holder.add_child(inst)
	inst.animation_player.play(collectible_animation)

func update_collectible(amount: int) -> void:
	collectible_label.text = collectible_amount_template % amount
