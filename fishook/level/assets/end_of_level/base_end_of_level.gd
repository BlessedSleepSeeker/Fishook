extends Area3D
class_name BaseEndOfLevel

signal end_of_level_reached

@onready var particles: GPUParticles3D = null#%EnteredParticles
@onready var stream_player: AudioStreamPlayer = %EnteredAudio

func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterInstance:
		end_of_level_reached.emit()
		if particles:
			particles.emitting = true
		if stream_player:
			stream_player.play()
		self.queue_free()