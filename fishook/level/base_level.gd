extends Node3D
class_name BaseLevel

@export var debug_collectible_timer_template: String = "Collectible %s : %s"

@export var level_down_limit: float = 50

@export var register_collectibles_: bool = true
@export var register_checkpoints_: bool = true
@export var randomize_spawn_point: bool = false

@onready var character: CharacterInstance = %CharacterInstance
@onready var current_checkpoint = null
@onready var hud: LevelHUD = %LevelHud
@onready var level_stopwatch: Stopwatch = %LevelStopwatch
@onready var debug_canvas: DebugCanvas = $DebugCanvasLayer

@onready var root: CustomRoot = get_tree().root.get_node("Root")

var total_collectibles: int = 0
var collected_amount: int = 0

func _ready():
	if register_collectibles_:
		register_collectibles()
	if register_checkpoints_:
		register_checkpoints()
	if randomize_spawn_point:
		randomize_spawn()
	else:
		find_spawn()
	character.debug_canvas = debug_canvas

func register_collectibles() -> void:
	for collectible: BaseCollectible in get_tree().get_nodes_in_group("Collectible"):
		collectible.collected.connect(picked_up_collectible)
	total_collectibles = get_tree().get_nodes_in_group("Collectible").size()
	hud.update_collectible(collected_amount, total_collectibles)

func picked_up_collectible(_collectible: BaseCollectible) -> void:
	collected_amount += 1
	hud.update_collectible(collected_amount, total_collectibles)
	print_debug(debug_collectible_timer_template % [collected_amount, level_stopwatch.get_current_time_as_string()])
	if collected_amount >= total_collectibles:
		level_stopwatch.pause = true
		print_debug("Final Time : %s" % [level_stopwatch.get_current_time_as_string()])

func register_checkpoints() -> void:
	for checkpoint: BaseCheckpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.reached.connect(reached_checkpoint)

func reached_checkpoint(checkpoint: BaseCheckpoint) -> void:
	current_checkpoint = checkpoint

func randomize_spawn() -> void:
	var checkpoints: Array = get_tree().get_nodes_in_group("Checkpoint")
	if checkpoints.size() > 0:
		var rng_index: int = RNGHandler.rng.randi_range(0, checkpoints.size() - 1)
		current_checkpoint = checkpoints[rng_index]
		teleport_player_to_checkpoint()

func find_spawn() -> void:
	var checkpoints: Array = get_tree().get_nodes_in_group("Checkpoint")
	for checkpoint: BaseCheckpoint in checkpoints:
		if checkpoint.name == "FirstCheckpoint":
			current_checkpoint = checkpoint

func _process(_delta):
	update_timer()

func _physics_process(_delta):
	if character.global_position.y < level_down_limit && is_respawning == false:
		teleport_player_to_checkpoint()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_debug_toggle"):
		debug_canvas.visible = !debug_canvas.visible

var is_respawning: bool = false
func teleport_player_to_checkpoint() -> void:
	is_respawning = true
	if root:
		await root.play_fade(true, true)
	character.respawn(current_checkpoint.global_position)
	if root:
		root.play_fade(false, false)
	is_respawning = false

func update_timer() -> void:
	var time_dict = level_stopwatch.get_current_time_dict()
	hud.update_timer(time_dict)
