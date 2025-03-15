extends Resource
class_name CameraParameters

@export var CAMERA_CONTROLLER_ROTATION_SPEED: float = 3.0
@export var CAMERA_MOUSE_SENSIBILITY: float = 0.1
# A minimum angle lower than or equal to -90 breaks movement if the player is looking upward.
@export var CAMERA_X_ROT_MIN: float = deg_to_rad(-89.9)
@export var CAMERA_X_ROT_MAX: float = deg_to_rad(70)