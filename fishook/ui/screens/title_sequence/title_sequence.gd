extends Setting

@export_file(".tscn") var main_menu_path: String = "res://ui/screens/main_menu/main_menu.tscn"
@onready var sprite: AnimatedSprite2D = $"%LogoAnimation"
@onready var subviewport_container: SubViewportContainer = $"%SubViewportContainer"

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

func _ready():
	if OS.has_feature("editor"):
		transition_by_path.emit(main_menu_path, {}, false, "")
	subviewport_container.size = DisplayServer.window_get_size()
	sprite.scale = Vector2(subviewport_container.size.x / 64, subviewport_container.size.y / 36)
	sprite.play("logo")
	await sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	transition_by_path.emit(main_menu_path, {}, false, "")

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		transition_by_path.emit(main_menu_path, {}, false, "")