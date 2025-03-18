extends CharacterState
class_name RunState

@export var walk_treshold: float = 0.4

func enter(_msg := {}) -> void:
	super()

func walk(_prev_anim: String):
	play_animation()

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.velocity.length() < walk_treshold:
		state_machine.transition_to("Walk")

func exit() -> void:
	pass
