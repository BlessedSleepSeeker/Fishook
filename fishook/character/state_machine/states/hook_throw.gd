extends CharacterState
class_name HookThrowState

var hookshot_raycast: RayCast3D = null

@export var spawn_debug: bool = false
@export var debug_ball: PackedScene = preload("res://debug/DebugBall.tscn")

func enter(_msg := {}) -> void:
	super()
	hookshot_raycast = character.camera.raycast
	character.skin.animation_tree.animation_finished.connect(look_for_hookshot_hit)

func look_for_hookshot_hit(_arg) -> void:
	if hookshot_raycast.is_colliding():
		if spawn_debug:
			var inst: StaticBody3D = debug_ball.instantiate()
			add_child(inst)
			inst.global_position = hookshot_raycast.get_collision_point()
		state_machine.transition_to("HookActivated")
	else:
		state_machine.transition_to("Fall")

func exit() -> void:
	character.skin.animation_tree.animation_finished.disconnect(look_for_hookshot_hit)
