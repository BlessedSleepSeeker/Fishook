extends CharacterState
class_name JumpState

func enter(_msg := {}) -> void:
	character.velocity.y += physics_parameters.JUMP_IMPULSE
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float) -> void:
	super(_delta)
	
	if character.is_on_floor():
		state_machine.transition_to("Idle")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")
