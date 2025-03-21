extends CharacterState
class_name HookActivatedState

var hookshot_raycast: RayCast3D = null
var hookshot_point: Vector3 = Vector3.ZERO
var distance: float

var is_pulling: bool = false

var can_reset_dj: bool = false

@export var spawn_debug: bool = false
@export var debug_ball: PackedScene = preload("res://debug/DebugBall.tscn")

func enter(_msg := {}) -> void:
	super()
	## reset double jump
	hookshot_raycast = character.camera.raycast
	if hookshot_raycast.is_colliding():
		hookshot_point = hookshot_raycast.get_collision_point()
		distance = character.global_position.distance_to(hookshot_point)
	else:
		state_machine.transition_to("Fall")
	character.particles_manager.emit("HookTrail")

func unhandled_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("jump") && not character.did_double_jump:
		state_machine.transition_to("DoubleJump")
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Fall")
	if Input.is_action_pressed("action2"):
		is_pulling = true
	else:
		is_pulling = false


func physics_update(_delta: float, _move_character: bool = true):
	character.debug_canvas.set_hookshot_distance(distance)
	var direction: Vector3 = character.global_position.direction_to(hookshot_point)
	super(_delta, false)
	if is_pulling:
		pull(_delta, direction)
	swing(_delta)
	## reset double jump only if you've gone downward once
	if character.velocity.y < 0:
		can_reset_dj = true
	if can_reset_dj && character.velocity.y > 0:
		character.did_double_jump = false
	character.move_and_slide()
	if character.is_on_floor():
		state_machine.transition_to("Land")

func swing(_delta: float) -> void:
	## No need to adjust movement if we are not outside of range !
	var current_distance = character.global_position.distance_to(hookshot_point)
	if current_distance < distance:
		return

	## Find the future position with current velocity
	var future_pos = character.global_position + (character.velocity * _delta)
	## Find the position where your character should be when being attached to the hookshot.
	var new_point = hookshot_point + (hookshot_point.direction_to(future_pos) * distance)
	## Update velocity to go in the direction of the new_point.
	character.velocity = (new_point - character.global_position) / _delta
	#character.velocity *= 1.01

	if spawn_debug:
		var inst: StaticBody3D = debug_ball.instantiate()
		add_child(inst)
		inst.global_position = new_point

func pull(_delta: float, _direction: Vector3) -> void:
	var displacement = distance - physics_parameters.GRAPPLE_REST_LENGTH
	if displacement > 0:
		distance = character.global_position.distance_to(hookshot_point) - (physics_parameters.GRAPPLE_PULLING_SPEED * _delta)

func exit():
	character.particles_manager.stop("HookTrail")