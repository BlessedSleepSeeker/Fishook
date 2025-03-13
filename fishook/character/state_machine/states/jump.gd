extends CharacterState
class_name JumpState

func enter(_msg := {}) -> void:
	impulse = Vector3(0, 1, 0)
	if character.model_animation_player && loop_anim:
		character.model_animation_player.animation_finished.connect(play_animation)
	play_animation()

func handle_input(_event: InputEvent):
	if Input.is_action_pressed("right"):
		impulse += Vector3(1, 0, 0)
	if Input.is_action_pressed("left"):
		impulse += Vector3(-1, 0, 0)
	if Input.is_action_pressed("back"):
		impulse += Vector3(0, 0, 1)
	if Input.is_action_pressed("forward"):
		impulse += Vector3(0, 0, -1)

func physics_update(_delta: float) -> void:
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Idle")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")
