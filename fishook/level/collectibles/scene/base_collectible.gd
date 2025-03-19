extends Node3D
class_name BaseCollectible

@export var initial_animation_delay: float = 0
@export var initial_animation_name: String = "Hover"

@onready var area: Area3D = %Area3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var picked_up_particles: GPUParticles3D = %PickedUpParticles
@onready var hitbox: CollisionShape3D = %Hitbox

signal collected(collectible: BaseCollectible)

func _ready():
	area.body_entered.connect(_on_body_entered)
	play_animation_with_delay(initial_animation_name, initial_animation_delay)

func play_animation_with_delay(animation_name: String, delay: float) -> void:
	if delay <= 0:
		animation_player.play(animation_name)
	else:
		await get_tree().create_timer(delay).timeout
		animation_player.play(animation_name)

func _on_body_entered(_body: Node3D):
	hitbox.disabled = true
	animation_player.play("PickedUp")
	picked_up_particles.emitting = true
	audio_stream_player.play()
	collected.emit(self)
	await animation_player.animation_finished
	self.queue_free()