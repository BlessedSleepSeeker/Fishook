class_name CharacterState
extends State

var character: CharacterInstance

@export var default_physics: bool = true
@export var handle_movements_input: bool = true
@export var handle_camera_input: bool = true

@export_group("Parameters")
@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()
@export var camera_parameters: CameraParameters = CameraParameters.new()

func _ready() -> void:
	character = owner as CharacterInstance

func enter(_msg := {}) -> void:
	character.camera.parameters = self.camera_parameters
	character.camera.raycast_range = physics_parameters.GRAPPLE_MAX_RANGE
	play_animation()

func input(_event: InputEvent) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	if handle_movements_input:
		character.raw_input = Input.get_vector("left", "right", "forward", "back")
		var forward: Vector3 = character.camera.real_camera.global_basis.z
		var right: Vector3 = character.camera.real_camera.global_basis.x

		character.direction = forward * character.raw_input.y + right * character.raw_input.x
		character.direction.y = 0.0
		character.direction = character.direction.normalized()

func physics_update(_delta: float) -> void:
	if handle_camera_input:
		character.camera.rotate_camera(_delta)
	
	if default_physics:
		## Extracting vertical velocity
		var y_velocity: float = character.velocity.y
		character.velocity.y = 0.0
		
		## Horizontal Movement.
		## If we have no movement, stop using acceleration and use friction instead.
		if character.raw_input == Vector2.ZERO:
			character.velocity = character.velocity.move_toward(character.direction * physics_parameters.MAX_SPEED, physics_parameters.FRICTION * _delta)
		else:
			character.velocity = character.velocity.move_toward(character.direction * physics_parameters.MAX_SPEED, physics_parameters.ACCELERATION * _delta)

		## Incorporating vertical velocity back into the mix.
		character.velocity.y = y_velocity + physics_parameters.GRAVITY * _delta

		character.move_and_slide()
		
		## Reseting raw input
		character.raw_input = Vector2.ZERO

		## character angling
		if character.direction.length() > 0.2:
			character.last_movement_direction = character.direction
		var target_angle: float = Vector3.BACK.signed_angle_to(character.last_movement_direction, Vector3.UP)
		character.skin.global_rotation.y = lerp_angle(character.skin.rotation.y, target_angle, physics_parameters.ROTATION_SPEED * _delta)

func exit() -> void:
	pass

func play_animation(_anim_name: String = "") -> void:
	if _anim_name:
		character.play_animation(_anim_name)
	else:
		character.play_animation(self.name)
