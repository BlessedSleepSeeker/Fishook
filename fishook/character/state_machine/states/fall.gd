extends CharacterState
class_name FallState

func enter(_msg := {}) -> void:
	super()

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_pressed("jump") && not character.did_double_jump:
		state_machine.transition_to("DoubleJump")
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("HookAiming")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")
