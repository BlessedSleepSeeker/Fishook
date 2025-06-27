extends Node3D
class_name CarrouselRender

@export var levels: Array[LevelData]
@export var distance: float = 5
@export var rotation_speed: float = 0.5

@onready var carrousel: Node3D = %Carrousel

func build() -> void:
	var index: int = 0
	for level: LevelData in levels:
		var scene = load(level.miniature_scene_path)
		var inst = scene.instantiate()
		carrousel.add_child(inst)
		var rotation_deg: float = get_rotation_for_index(index)
		inst.position.x = distance * sin(deg_to_rad(rotation_deg)) + distance * cos(deg_to_rad(rotation_deg))
		inst.position.z = -(distance * sin(deg_to_rad(rotation_deg))) + distance * cos(deg_to_rad(rotation_deg))
		index += 1

## Return degrees
func get_rotation_for_index(index: int) -> float:
	var per_level: float = 360.0 / levels.size()
	return (per_level * index)


func rotate_for_index(index: int) -> void:
	var rotation_target: float = lerp_angle(carrousel.rotation.y, deg_to_rad(get_rotation_for_index(index) * -1), 1)

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(carrousel, "rotation:y", rotation_target, rotation_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
