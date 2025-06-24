extends RigidBody3D
class_name RigidbodyCollectible

@export var rotation_min: Vector3 = Vector3(-180, -180, -180)
@export var rotation_max: Vector3 = Vector3(180, 180, 180)
@export var position_min: Vector3 = Vector3(-0.3, -0.3, -0.3)
@export var position_max: Vector3 = Vector3(0.3, 0.3, 0.3)

@export var randomize_on_ready: bool = true
@export var play_sound_on_collision: bool = true

@onready var stream_player: RandomStreamPlayer = %RandomStreamPlayer
@onready var stream_cooldown: Timer = %SoundCooldown

func _ready():
	if randomize_on_ready:
		randomize_orientation()
		randomize_position()
	if play_sound_on_collision:
		self.body_entered.connect(play_sound)

func randomize_orientation() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	self.rotation_degrees.x = rng.randf_range(rotation_min.x, rotation_max.x)
	self.rotation_degrees.y = rng.randf_range(rotation_min.y, rotation_max.y)
	self.rotation_degrees.z = rng.randf_range(rotation_min.z, rotation_max.z)

func randomize_position() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	self.position.x = rng.randf_range(position_min.x, position_max.x)
	self.position.y = rng.randf_range(position_min.y, position_max.y)
	self.position.z = rng.randf_range(position_min.z, position_max.z)


func play_sound(_body: Node3D) -> void:
	if stream_cooldown.time_left == 0:
		stream_player.play_random()
		stream_cooldown.start()