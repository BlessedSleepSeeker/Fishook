extends CharacterState
class_name HookActivatedState

var hookshot_raycast: RayCast3D = null
var hookshot_point: Vector3 = Vector3.ZERO

var is_pulling: bool = false

func enter(_msg := {}) -> void:
	super()
	## reset double jump
	character.did_double_jump = false
	hookshot_raycast = character.camera.raycast
	if hookshot_raycast.is_colliding():
		hookshot_point = hookshot_raycast.get_collision_point()
	else:
		state_machine.transition_to("Fall")
	play_animation("HookActivate")

func unhandled_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_released("action1"):
		state_machine.transition_to("Fall")
	if Input.is_action_pressed("action2"):
		is_pulling = true
	else:
		is_pulling = false


func physics_update(_delta: float):
	swing(_delta)
	if is_pulling:
		pull(_delta)
	super(_delta)

func swing(_delta: float) -> void:
	var distance_to_keep: Vector3 = character.global_position - hookshot_point
	#var new_pos_without_swing: Vector3 = character.global_position + (character.velocity * _delta)


func pull(_delta: float) -> void:
	var direction: Vector3 = (hookshot_point - character.global_position).normalized()
	character.velocity += direction * physics_parameters.GRAPPLE_PULLING_SPEED * _delta
