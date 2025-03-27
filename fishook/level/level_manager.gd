extends Node
class_name LevelManager

@export var level_scene_path: String = "res://level/levels/"
@export var level_scene_name: String = "Level1.tscn"

@onready var level_holder: Node3D = %LevelHolder

func _ready():
	load_level()

func flush_level() -> void:
	for child in level_holder.get_children():
		child.queue_free()

## connect to signal like "level_finished" or things like that
func load_level() -> void:
	var level_scene: PackedScene = load(build_level_path())
	var level_instance = level_scene.instantiate()
	level_holder.add_child(level_instance)

func build_level_path() -> String:
	return level_scene_path + level_scene_name