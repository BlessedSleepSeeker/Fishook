extends Node3D
class_name BaseLevel

@onready var character: CharacterInstance = %CharacterInstance
@onready var current_checkpoint = %FirstCheckpoint

func _ready():
	register_collectibles()
	register_checkpoints()

func register_collectibles() -> void:
	for collectible: BaseCollectible in get_tree().get_nodes_in_group("Collectible"):
		collectible.collected.emit(picked_up_collectible)

func picked_up_collectible(collectible: BaseCollectible) -> void:
	pass

func register_checkpoints() -> void:
	for checkpoint: BaseCheckpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.reached.connect(reached_checkpoint)

func reached_checkpoint(checkpoint: BaseCheckpoint) -> void:
	current_checkpoint = checkpoint

func _physics_process(_delta):
	if character.global_position.y < 50:
		teleport_player_to_checkpoint()

func teleport_player_to_checkpoint() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(character, "global_position", current_checkpoint.global_position, 1).set_ease(Tween.EASE_IN_OUT)
