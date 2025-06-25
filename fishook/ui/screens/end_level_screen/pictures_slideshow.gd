extends Control
class_name PictureSlideshow

@export var picture_scene: PackedScene = preload("res://ui/screens/end_level_screen/EndLevelPicture.tscn")

@onready var origin: Control = $Control

func display_picture(texture: ImageTexture) -> void:
	var instance: EndLevelPicture = picture_scene.instantiate()
	instance.set_deferred("position", -texture.get_size() / 2)
	instance.set_deferred("pivot_offset", texture.get_size() / 2)
	origin.add_child(instance)
	instance.add_texture(texture)