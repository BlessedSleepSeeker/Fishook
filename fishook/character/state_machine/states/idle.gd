extends CharacterState
class_name IdleState

@export var min_loop_before_fidget: int = 1
@export var fidget_chance: int = 50
var current_loop: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func enter(_msg := {}) -> void:
	current_loop = 0
	if character.model_animation_player && loop_anim:
		character.model_animation_player.animation_finished.connect(roll_for_fidget)
	play_animation()

func roll_for_fidget(_finished_animation: String):
	if current_loop >= min_loop_before_fidget && fidget_chance >= rng.randi_range(1, 100):
		play_animation("IdleFidget")
		current_loop = 0
	else:
		play_animation()
		current_loop += 1

func handle_input(_event: InputEvent):
	if Input.is_action_pressed("forward"):
		state_machine.transition_to("Walk")
	if Input.is_action_pressed("back"):
		state_machine.transition_to("Walk")
	if Input.is_action_pressed("right"):
		state_machine.transition_to("Walk")
	if Input.is_action_pressed("left"):
		state_machine.transition_to("Walk")
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")

func physics_update(_delta: float) -> void:
	super(_delta)
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")

func exit() -> void:
	if character.model_animation_player && character.model_animation_player.animation_finished.is_connected(roll_for_fidget):
		character.model_animation_player.animation_finished.disconnect(roll_for_fidget)