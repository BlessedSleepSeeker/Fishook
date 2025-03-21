extends Node3D
class_name BaseLevel

@onready var character: CharacterInstance = %CharacterInstance
@onready var current_checkpoint = %FirstCheckpoint
@onready var hud: LevelHUD = %LevelHud
@onready var level_stopwatch: Stopwatch = %LevelStopwatch

var total_collectibles: int = 0
var collected_amount: int = 0

func _ready():
	register_collectibles()
	register_checkpoints()

func register_collectibles() -> void:
	for collectible: BaseCollectible in get_tree().get_nodes_in_group("Collectible"):
		collectible.collected.connect(picked_up_collectible)
	total_collectibles = get_tree().get_nodes_in_group("Collectible").size()
	hud.update_collectible(collected_amount, total_collectibles)

func picked_up_collectible(_collectible: BaseCollectible) -> void:
	collected_amount += 1
	hud.update_collectible(collected_amount, total_collectibles)
	if collected_amount >= total_collectibles:
		level_stopwatch.pause = true

func register_checkpoints() -> void:
	for checkpoint: BaseCheckpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.reached.connect(reached_checkpoint)

func reached_checkpoint(checkpoint: BaseCheckpoint) -> void:
	current_checkpoint = checkpoint

func _process(_delta):
	update_timer()

func _physics_process(_delta):
	if character.global_position.y < 50:
		teleport_player_to_checkpoint()

func teleport_player_to_checkpoint() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(character, "global_position", current_checkpoint.global_position, 1).set_ease(Tween.EASE_IN_OUT)

func update_timer() -> void:
	var time_dict = level_stopwatch.get_current_time_dict()
	hud.update_timer(time_dict)
