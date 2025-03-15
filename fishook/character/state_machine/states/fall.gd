extends CharacterState
class_name FallState

func enter(_msg := {}) -> void:
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float) -> void:
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Idle")
