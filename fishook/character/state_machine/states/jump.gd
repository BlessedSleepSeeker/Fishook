extends CharacterState
class_name JumpState

@export var dj_minimum_delay: int = 6

@onready var rdm_stream_player: RandomStreamPlayer = $RandomStreamPlayer

var current_frame: int = 0

func enter(_msg := {}) -> void:
	character.velocity.y += physics_parameters.JUMP_IMPULSE
	rdm_stream_player.play_random()
	fade_crosshair(true)
	current_frame = 0
	super()

func unhandled_input(_event: InputEvent):
	super(_event)
	print(_event.as_text())
	if Input.is_action_just_pressed("jump") && not character.did_double_jump && current_frame > dj_minimum_delay:
		state_machine.transition_to("DoubleJump")
	if Input.is_action_just_pressed("throw_hook"):
		state_machine.transition_to("HookAiming")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")
	current_frame += 1
