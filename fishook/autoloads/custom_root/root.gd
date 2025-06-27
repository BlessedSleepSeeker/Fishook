extends Node
class_name CustomRoot

@export var first_scene: PackedScene = preload("res://ui/screens/title_sequence/title_sequence.tscn")
@onready var loading_screen: LoadingScreen = %LoadingScreen
@export_range(0.1, 10, 0.1) var transition_speed: float = 0.5

@onready var settings = $Settings
@onready var scene_root = $SceneRoot
@onready var transition_color_rect: ColorRect = %Transition
@onready var fade_to_black_color_rect: ColorRect = %FadeToBlack

@onready var thread: Thread = Thread.new()

signal transition_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	add_packed_scene_to_tree(first_scene)

func flush_scenes() -> void:
	for child in scene_root.get_children():
		child.queue_free()

func add_packed_scene_to_tree(new_scene: PackedScene, scene_parameters: Dictionary = {}, instantiate_from_thread: bool = false) -> void:
	var instance = null#
	if instantiate_from_thread:
		thread.start(new_scene.instantiate)
		instance = thread.wait_to_finish()
	else:
		instance = new_scene.instantiate()
	# if instance.has_signal("transition") and not instance.transition.is_connected(_on_transition):
	# 	instance.transition.connect(_on_transition)
	if instance.has_signal("transition_by_path") and not instance.transition_by_path.is_connected(_on_transition_by_path):
		instance.transition_by_path.connect(_on_transition_by_path)
	if instance.has_signal("play_transition") and not instance.play_transition.is_connected(play_transition):
		instance.play_transition.connect(play_transition)
	# if instance.has_signal("transition_by_instance") and not instance.transition_by_instance.is_connected(_on_transition_by_instance):
	# 	instance.transition_by_instance.connect(_on_transition_by_instance)

	for parameter in scene_parameters:
		instance.set(parameter, scene_parameters[parameter])
	if instantiate_from_thread:
		thread.start(scene_root.call_deferred.bind("add_child", instance))
		thread.wait_to_finish()
	else:
		scene_root.add_child(instance)

func change_scene(new_scene_path: String, scene_parameters: Dictionary = {}) -> void:
	flush_scenes()
	var new_scene: PackedScene = load(new_scene_path)
	add_packed_scene_to_tree(new_scene, scene_parameters)

func add_scene_with_loading_screen(new_scene_path: String, scene_parameters: Dictionary = {}) -> void:
	#print("adding scene async")
	ResourceLoader.load_threaded_request(new_scene_path)
	var progress = []

	ResourceLoader.load_threaded_get_status(new_scene_path, progress)

	while progress[0] != 1:
		#print("progress = %d" % progress[0])
		loading_screen.update_bar(progress[0] * 100, "Loading...")
		ResourceLoader.load_threaded_get_status(new_scene_path, progress)
		await get_tree().create_timer(0.01).timeout
	
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(new_scene_path)

	#print("finished loading, now adding scene")
	add_packed_scene_to_tree(new_scene, scene_parameters, true)
	await get_tree().create_timer(0.2).timeout


func change_scene_with_loading_screen(new_scene_path: String, scene_parameters: Dictionary = {}) -> void:
	flush_scenes()
	await add_scene_with_loading_screen(new_scene_path, scene_parameters)

func play_transition(direction: bool = true, wait_for_tween: bool = true) -> void:
	var tween: Tween = get_tree().create_tween()
	var tween_value: float = 1
	if not direction:
		tween_value = 0
	tween.tween_property(transition_color_rect.material, "shader_parameter/progress", tween_value, transition_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	if wait_for_tween:
		await tween.finished

func play_fade(direction: bool = true, wait_for_tween: bool = true) -> void:
	var tween: Tween = get_tree().create_tween()
	var tween_value: float = 1
	if not direction:
		tween_value = 0
	tween.tween_property(fade_to_black_color_rect.material, "shader_parameter/progress", tween_value, transition_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	if wait_for_tween:
		await tween.finished

# func _on_transition(new_scene: PackedScene, animation: String = "") -> void:
# 	if animation != "":
# 		await play_transition(true)
# 		change_scene(new_scene)
# 		await get_tree().create_timer(0.2).timeout
# 		play_transition(false, false)
# 	else:
# 		change_scene(new_scene)

func _on_transition_by_path(new_scene_path: String, scene_parameters: Dictionary = {}, toggle_loading_screen: bool = true, animation: String = "") -> void:
	#print("going to %s with %s, %s, %s" % [new_scene_path, scene_parameters, toggle_loading_screen, animation])
	if animation != "":
		await play_transition(true)
		if toggle_loading_screen:
			loading_screen.show()
			play_transition(false, false)
			await change_scene_with_loading_screen(new_scene_path, scene_parameters)
			await play_transition(true)
			loading_screen.hide()
		else:
			change_scene(new_scene_path, scene_parameters)
			await get_tree().create_timer(0.2).timeout
		play_transition(false, true)
	else:
		if toggle_loading_screen:
			await change_scene_with_loading_screen(new_scene_path, scene_parameters)
		else:
			change_scene(new_scene_path, scene_parameters)
	transition_finished.emit()
	

# func _on_transition_by_instance(new_instance: Node) -> void:
# 	await play_transition(true)
# 	flush_scenes()
# 	scene_root.add_child(new_instance)
# 	await get_tree().create_timer(0.2).timeout
# 	play_transition(false, false)
