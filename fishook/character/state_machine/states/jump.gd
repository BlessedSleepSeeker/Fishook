extends CharacterState
class_name JumpState

@onready var rdm_stream_player: RandomStreamPlayer = $RandomStreamPlayer

func enter(_msg := {}) -> void:
	character.velocity.y += physics_parameters.JUMP_IMPULSE
	rdm_stream_player.play_random()
	fade_crosshair(true)
	super()

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_pressed("jump") && not character.did_double_jump:
		state_machine.transition_to("DoubleJump")
	if Input.is_action_just_pressed("throw_hook"):
		state_machine.transition_to("HookAiming")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")
