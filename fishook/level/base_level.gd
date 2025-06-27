extends Node3D
class_name BaseLevel

enum LevelType {
	REACH_THE_END,
	COLLECTATHON
}
@export var level_type: LevelType = LevelType.REACH_THE_END
@export var meta_data: LevelData = LevelData.new()

@export var level_down_limit: float = 50

@export var speedrun_mode: bool = false
@export var register_collectibles_: bool = true
@export var register_checkpoints_: bool = true
@export var randomize_spawn_point: bool = false
@export var register_dialog_boxes_: bool = true
@export_node_path("BaseEndOfLevel") var end_level_trigger_path

@export var debug_collectible_timer_template: String = "Collectible %s : %s"


@onready var character: CharacterInstance = %CharacterInstance
@onready var current_checkpoint = null
@onready var level_stopwatch: Stopwatch = %LevelStopwatch
@onready var debug_canvas: DebugCanvas = $DebugCanvasLayer
@onready var level_hud: LevelHUD = %LevelHud
@onready var dialog_hud: DialogHUD = %DialogHUD
@onready var end_level_hud: EndLevelScreen = %EndLevelScreen
@onready var music_player: LevelMusicPlayer = %LevelMusicPlayer

@onready var root: CustomRoot = get_tree().root.get_node("Root")

var end_level_trigger: BaseEndOfLevel = null

var total_collectibles: int = 0
var collected_amount: int = 0

signal replay
signal go_to_level_selector

func _ready():
	InputHandler.handle_mouse(false)
	Engine.time_scale = 1
	if register_collectibles_:
		register_collectibles()
	if register_checkpoints_:
		register_checkpoints()
	if register_dialog_boxes_:
		register_dialog_boxes()
	if randomize_spawn_point:
		randomize_spawn()
	else:
		find_spawn()
	if self.level_type == LevelType.REACH_THE_END:
		register_end_of_level()
	setup_end_screen()
	character.debug_canvas = debug_canvas

	if speedrun_mode:
		setup_speedrun_mode()
	else:
		level_stopwatch.pause = false


#region Registering
func register_collectibles() -> void:
	for collectible: BaseCollectible in get_tree().get_nodes_in_group("Collectible"):
		collectible.collected.connect(picked_up_collectible)
	total_collectibles = get_tree().get_nodes_in_group("Collectible").size()
	level_hud.update_collectible(collected_amount, total_collectibles)

func picked_up_collectible(_collectible: BaseCollectible) -> void:
	collected_amount += 1
	level_hud.update_collectible(collected_amount, total_collectibles)
	print_debug(debug_collectible_timer_template % [collected_amount, level_stopwatch.get_current_time_as_string()])
	if collected_amount >= total_collectibles:
		print_debug("Final Time : %s" % [level_stopwatch.get_current_time_as_string()])
		if level_type == LevelType.COLLECTATHON:
			_on_end_of_level_reached()
	## screenshots
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	await get_tree().create_timer(rng.randf_range(0.1, 0.5)).timeout
	character.camera.screenshot_camera.snap_picture()

func register_checkpoints() -> void:
	for checkpoint: BaseCheckpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.reached.connect(reached_checkpoint)

func reached_checkpoint(checkpoint: BaseCheckpoint) -> void:
	current_checkpoint = checkpoint

func register_dialog_boxes() -> void:
	for trigger_box: DialogTriggerBox in get_tree().get_nodes_in_group("DialogTriggerBox"):
		trigger_box.display_dialog.connect(display_dialog)
		trigger_box.hide_dialog.connect(hide_dialog_if_needed)

func display_dialog(dialog_text: String, fade_dialog_after: float, use_letter_by_letter: bool) -> void:
	dialog_hud.update_dialog(dialog_text, fade_dialog_after, use_letter_by_letter)

func hide_dialog_if_needed(dialog_text: String) -> void:
	if dialog_hud.is_text_currently_displayed(dialog_text):
		dialog_hud.hide_dialog()

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

func register_end_of_level() -> void:
	end_level_trigger = get_node(end_level_trigger_path)
	end_level_trigger.end_of_level_reached.connect(_on_end_of_level_reached)

func setup_end_screen() -> void:
	end_level_hud.setup(meta_data, total_collectibles)
	end_level_hud.replay.connect(self.replay.emit)
	end_level_hud.level_select.connect(self.go_to_level_selector.emit)

func setup_speedrun_mode() -> void:
	character.state_machine.transition_to("UncontrollableCinematic")
	level_hud.setup_speedrun_mode()
	await level_hud.speedrun_animation_finished
	character.state_machine.transition_to("Idle")
	level_stopwatch.pause = false

#endregion

#region Processing
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
	level_hud.update_timer(time_dict)

func _on_end_of_level_reached():
	end_level_hud.pictures = character.camera.screenshot_camera.pictures
	if music_player:
		music_player.change_volume(-12, 3)
		music_player.input_disabled = true
	level_stopwatch.pause = true
	if dialog_hud:
		dialog_hud.hide_dialog()
	if level_hud:
		level_hud.fade_hud()
	#var tween: Tween = get_tree().create_tween()
	#tween.tween_property(Engine, "time_scale", 0.1, 0.5).set_trans(Tween.TRANS_CUBIC)
	character.tween_velocity(Vector3.ZERO, 1)
	await character.velocity_tweened
	character.state_machine.transition_to("UncontrollableCinematic", {"animation_name": "FishingIdle"})
	end_level_hud.start_recap({
		"final_time": level_stopwatch.get_current_time_dict(),
		"collected_amount": collected_amount
	})

#endregion
