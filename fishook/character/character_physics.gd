extends Resource
class_name CharacterPhysics


@export var GRAVITY: float = -30
@export var JUMP_IMPULSE: float = 12

@export var ACCELERATION: float = 20
@export var MAX_SPEED: float = 8
@export var FRICTION: float = 40

@export var ROTATION_SPEED: float = 6.0

@export_group("Grappling Hook Physics")
@export var GRAPPLE_MAX_RANGE: float = 30
@export var GRAPPLE_REST_LENGTH: float = 0.1
@export var GRAPPLE_SWING_SPEED: float = 70
@export var GRAPPLE_PULLING_SPEED: float = 3
@export var GRAPPLE_FRICTION: float = 0.995