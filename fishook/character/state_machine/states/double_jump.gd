extends CharacterState
class_name DoubleJumpState

func enter(_msg := {}) -> void:
	character.did_double_jump = true
	character.velocity.y = physics_parameters.JUMP_IMPULSE
	character.particles_manager.emit("SmokeCloudDJ")
	super()
	play_animation("Jump")

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("HookThrow")

func physics_update(_delta: float) -> void:
	super(_delta)
	
	if character.is_on_floor():
		state_machine.transition_to("Idle")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")