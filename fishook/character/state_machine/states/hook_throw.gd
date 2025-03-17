extends CharacterState
class_name HookThrowState

var frame_nbr: int = 0
@export var startup_duration: int = 6
var hookshot_raycast: RayCast3D = null

@export var spawn_debug: bool = false
@export var debug_ball: PackedScene = preload("res://debug/DebugBall.tscn")

var prev_state_name: String = "Idle"

func enter(_msg := {}) -> void:
	super()
	hookshot_raycast = character.camera.raycast
	prev_state_name = _msg["PreviousState"]
	play_animation("HookActivate")

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if frame_nbr >= startup_duration:
		look_for_hookshot_hit()
	frame_nbr += 1

func look_for_hookshot_hit() -> void:
	if hookshot_raycast.is_colliding():
		if spawn_debug:
			var inst: StaticBody3D = debug_ball.instantiate()
			add_child(inst)
			inst.global_position = hookshot_raycast.get_collision_point()
		state_machine.transition_to("HookActivated")
	else:
		state_machine.transition_to("Idle")

func exit() -> void:
	pass
