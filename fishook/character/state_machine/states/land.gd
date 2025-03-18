extends CharacterState
class_name LandState

func enter(_msg := {}) -> void:
	character.did_double_jump = false
	character.particles_manager.emit("SmokeCloudLanding")
	super()
	character.skin.animation_tree.animation_finished.connect(animation_finished)

func unhandled_input(_event: InputEvent):
	super(_event)
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

func animation_finished(_animation_name: String) -> void:
	state_machine.transition_to("Idle")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)

func exit() -> void:
	character.skin.animation_tree.animation_finished.disconnect(animation_finished)
