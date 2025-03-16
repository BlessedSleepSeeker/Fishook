extends CharacterState
class_name HookThrowState

var frame_nbr: int = 0
@export var startup_duration: int = 6
var hookshot_raycast: RayCast3D = null

var prev_state_name: String = "Idle"

func enter(_msg := {}) -> void:
	super()
	hookshot_raycast = character.camera.raycast
	prev_state_name = _msg["PreviousState"]
	play_animation("HookActivate")

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float) -> void:
	if frame_nbr >= startup_duration:
		look_for_hookshot_hit()
	frame_nbr += 1
	super(_delta)

func look_for_hookshot_hit() -> void:
	if hookshot_raycast.is_colliding():
		state_machine.transition_to("HookActivated")
	else:
		state_machine.transition_to("Idle")

func exit() -> void:
	pass
