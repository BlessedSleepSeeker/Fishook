extends Node3D
class_name MouseFollowCamera

@export var parameters: CameraParameters = CameraParameters.new()

@onready var real_camera: Camera3D = %Camera3D
@onready var raycast: RayCast3D = %HookRayCast
@onready var behind: Marker3D = %Behind
# @onready var sphere_indicator: Node3D = %ShpereIndicator

signal is_colliding(is_colliding: bool)

var raycast_range: float = 10:
	set(value):
		raycast_range = value
		raycast.target_position.z = -value

var _camera_input_direction: Vector2 = Vector2.ZERO

var character: CharacterInstance

func _ready():
	character = owner as CharacterInstance

func _unhandled_input(_event: InputEvent):
	# Make mouse aiming speed resolution-independent
	# (required when using the `canvas_items` stretch mode).
	var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
	)

	if _event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_camera_input_direction = _event.screen_relative * parameters.CAMERA_MOUSE_SENSIBILITY * scale_factor

func rotate_camera(_delta) -> void:
	#print(character.bullet_time_on)
	if character.bullet_time_on:
		self.rotation.x += self._camera_input_direction.y * (_delta * 5)
	else:
		self.rotation.x += self._camera_input_direction.y * _delta
	self.rotation.x = clampf(self.rotation.x, parameters.CAMERA_X_ROT_MIN, parameters.CAMERA_X_ROT_MAX)

	self.rotation.y -= self._camera_input_direction.x * _delta
	if character.bullet_time_on:
		self.rotation.y -= self._camera_input_direction.x * (_delta * 5) 
	else:
		self.rotation.y -= self._camera_input_direction.x * _delta
	self.rotation.y = wrapf(self.rotation.y, 0.0, deg_to_rad(360))
	self._camera_input_direction = Vector2.ZERO

func _process(_delta):
	pass
	# var distance = self.global_position.distance_to(real_camera.global_position)
	# if distance <= parameters.CAMERA_TOO_CLOSE_RANGE:
	# 	var tween = get_tree().create_tween()
	# 	var behind_direction = self.global_position.direction_to(behind.global_position)
	# 	behind_direction.y = 0
	# 	print(behind_direction)
	# 	tween.tween_property(self, "position", parameters.CAMERA_TOO_CLOSE_OFFSET + (behind_direction * parameters.CAMERA_TOO_CLOSE_BEHIND_MULTIPLICATOR), parameters.CAMERA_TOO_CLOSE_MOVEMENT_TWEEN_SPEED)
	# else:
	# 	var tween = get_tree().create_tween()
	# 	tween.tween_property(self, "position", parameters.CAMERA_BASE_OFFSET, parameters.CAMERA_TOO_CLOSE_MOVEMENT_TWEEN_SPEED)

func _physics_process(_delta):
	if raycast.is_colliding():
		is_colliding.emit(true)
	else:
		is_colliding.emit(false)
	# 	sphere_indicator.global_position = raycast.get_collision_point()
	# 	sphere_indicator.show()
	# else:
	# 	sphere_indicator.hide()