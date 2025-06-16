extends CharacterState
class_name GlidingState

@export var normal_glide_gravity_clamp: float = -3
@export var fast_glide_gravity_clamp: float = -20

@export var normal_glide_horizontal_speed: float = 20
@export var fast_glide_horizontal_speed: float = 80

var fast_gliding: bool = false

func enter(_msg := {}) -> void:
	super()

func unhandled_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump") && not character.did_double_jump:
		state_machine.transition_to("DoubleJump")
	elif Input.is_action_just_pressed("throw_hook"):
		state_machine.transition_to("HookAiming")
	if Input.is_action_just_pressed("forward"):
		fast_gliding = true
	if Input.is_action_just_released("forward"):
		fast_gliding = false

	var tilt_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")

	var forward: Vector3 = character.camera.real_camera.global_basis.z
	var right: Vector3 = character.camera.real_camera.global_basis.x

	character.direction = forward * -1 + right * tilt_input
	character.direction.y = 0.0
	character.direction = character.direction.normalized()


func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")

	## Extracting vertical velocity
	var y_velocity: float = character.velocity.y
	character.velocity.y = 0.0

	print(character.direction)
	if not fast_gliding:
		character.velocity = character.velocity.move_toward(character.direction * normal_glide_horizontal_speed, _delta * 100)
	else:
		character.velocity = character.velocity.move_toward(character.direction * fast_glide_horizontal_speed, _delta * 100)
	## Incorporating vertical velocity back into the mix.
	character.velocity.y = y_velocity
	character.velocity.y += physics_parameters.GRAVITY * _delta
	# making sure we never fall faster than that
	if character.velocity.y < 0:
		if not fast_gliding:
			character.velocity.y = clampf(character.velocity.y, normal_glide_gravity_clamp, 0)
		else:
			character.velocity.y = clampf(character.velocity.y, fast_glide_gravity_clamp, 0)
	character.move_and_slide()