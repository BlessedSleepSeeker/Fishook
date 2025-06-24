extends Node3D
class_name CollectedCollectibles

@export var collected_amount: int = 8
@export var collectible_scene: PackedScene = preload("res://level/collectibles/scene/RigidbodyCollectible.tscn")

@export var initial_spawn_delay: float = 0.3
## Every spawned collectible will decrease the cooldown by this much
@export var spawn_delay_accel: float = 0.02

var spawn_delay: float = 0:
	set(value):
		if value > 0:
			spawn_delay = value

@onready var spawnpoint: Node3D = %Spawnpoint

signal spawned_collectible
signal finished_spawning

func _ready():
	pass#animate_collectibles_spawn()

func animate_collectibles_spawn() -> void:
	spawn_delay = initial_spawn_delay
	for i: int in range(0, collected_amount):
		spawn_collectible()
		await get_tree().create_timer(spawn_delay).timeout
		spawn_delay -= spawn_delay_accel
	finished_spawning.emit()

func spawn_collectible() -> void:
	var inst: RigidbodyCollectible = collectible_scene.instantiate()
	spawnpoint.add_child(inst)
	spawned_collectible.emit()