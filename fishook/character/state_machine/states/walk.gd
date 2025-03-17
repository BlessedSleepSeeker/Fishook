extends CharacterState
class_name WalkState

var frame_nbr: int = 0

## Will first play <Prevstate.name>ToWalk, if Idle = IdleToWalk then connect animation finished to play_animation which will be "Walk" if the node's name is "Walk"
func enter(_msg := {}) -> void:
	#prev_anim_name = anim_to_walk_template % _msg["PreviousState"]
	super()
	frame_nbr = 0

func walk(_prev_anim: String):
	play_animation()

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("HookThrow")
	if character.direction == Vector3.ZERO && frame_nbr > 3:
		state_machine.transition_to("Idle")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	frame_nbr += 1

func exit() -> void:
	pass
