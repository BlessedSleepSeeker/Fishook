extends Node3D
class_name RandomizedDecoration

@export var decoration_scene: PackedScene = preload("res://level/assets/decoration/models/flowers/RandomFlower.tscn")
@export var decoration_chance: float = 20

func randomize_for_decoration(chance_modifier: float = 0):
	if decoration_chance + chance_modifier >= RNGHandler.rng.randi_range(0, 100):
		var inst = decoration_scene.instantiate()
		add_child(inst)
