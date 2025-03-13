extends Resource
class_name CharacterPhysics

@export var gravity: float = -ProjectSettings.get_setting("physics/3d/default_gravity")

@export var accel: float = 20
@export var max_speed: float = 50
@export var friction: float = 0.7
