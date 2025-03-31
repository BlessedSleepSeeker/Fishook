class_name Root
extends Node

@export var first_client_scene: PackedScene = preload("res://ui/screens/title_sequence/title_sequence.tscn")
@export_range(0.1, 10, 0.1) var transition_speed: float = 0.5

@onready var settings = $Settings
@onready var scene_root = $SceneRoot
@onready var transition_color_rect: ColorRect = %ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	add_scene(first_client_scene)

func flush_scenes() -> void:
	for child in scene_root.get_children():
		child.queue_free()

func add_scene(new_scene: PackedScene, scene_parameters: Dictionary = {}) -> void:
	var instance = new_scene.instantiate()
	if instance.has_signal("transition") and not instance.transition.is_connected(_on_transition):
		instance.transition.connect(_on_transition)
	if instance.has_signal("transition_by_path") and not instance.transition_by_path.is_connected(_on_transition_by_path):
		instance.transition_by_path.connect(_on_transition_by_path)
	if instance.has_signal("play_transition") and not instance.play_transition.is_connected(play_transition):
		instance.play_transition.connect(play_transition)
	# if instance.has_signal("transition_by_instance") and not instance.transition_by_instance.is_connected(_on_transition_by_instance):
	# 	instance.transition_by_instance.connect(_on_transition_by_instance)

	for parameter in scene_parameters:
		instance.set(parameter, scene_parameters[parameter])
	scene_root.add_child(instance)

func change_scene(new_scene: PackedScene, scene_parameters: Dictionary = {}) -> void:
	flush_scenes()
	add_scene(new_scene, scene_parameters)

func play_transition(direction: bool = true, wait_for_tween: bool = true) -> void:
	var tween: Tween = get_tree().create_tween()
	if direction:
		tween.tween_property(transition_color_rect.material, "shader_parameter/progress", 1, transition_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(transition_color_rect.material, "shader_parameter/progress", 0, transition_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	if wait_for_tween:
		await tween.finished

func _on_transition(new_scene: PackedScene, animation: String = "") -> void:
	if animation != "":
		await play_transition(true)
		change_scene(new_scene)
		await get_tree().create_timer(0.2).timeout
		play_transition(false, false)
	else:
		change_scene(new_scene)

func _on_transition_by_path(new_scene_path: String, scene_parameters: Dictionary = {}) -> void:
	await play_transition(true)
	var new_scene: PackedScene = load(new_scene_path)
	change_scene(new_scene, scene_parameters)
	await get_tree().create_timer(0.2).timeout
	play_transition(false, false)


# func _on_transition_by_instance(new_instance: Node) -> void:
# 	await play_transition(true)
# 	flush_scenes()
# 	scene_root.add_child(new_instance)
# 	await get_tree().create_timer(0.2).timeout
# 	play_transition(false, false)
