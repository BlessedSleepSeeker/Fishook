extends CharacterState
class_name WalkState



## Will first play <Prevstate.name>ToWalk, if Idle = IdleToWalk then connect animation finished to play_animation which will be "Walk" if the node's name is "Walk"
func enter(_msg := {}) -> void:
	#prev_anim_name = anim_to_walk_template % _msg["PreviousState"]
	if character.model_animation_player && loop_anim:
		character.model_animation_player.animation_finished.connect(walk)
	play_animation()

func walk(_prev_anim: String):
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
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	if impulse == Vector3():
		state_machine.transition_to("Idle")

func physics_update(_delta: float) -> void:
	super(_delta)

func exit() -> void:
	if character.model_animation_player && character.model_animation_player.animation_finished.is_connected(walk):
		character.model_animation_player.animation_finished.disconnect(walk)