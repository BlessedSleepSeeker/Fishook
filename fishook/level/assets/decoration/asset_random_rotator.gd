@tool
extends Node
class_name AssetRandomRotator

@export var models: Array[NodePath]

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_x_min: float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_x_max: float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_y_min: float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_y_max: float = 360
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_z_min: float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_z_max: float = 0

func _ready():
	pass

@export_tool_button("Randomize Orientation", "Callable") var randomize_orient = randomize_orientation
func randomize_orientation() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	for model in models:
		var rot_x: float = rng.randf_range(rotation_x_min, rotation_x_max)
		var rot_y: float = rng.randf_range(rotation_y_min, rotation_y_max)
		var rot_z: float = rng.randf_range(rotation_z_min, rotation_z_max)
		var rot: Vector3 = Vector3(rot_x, rot_y, rot_z)

		var model_node: Node3D = get_node(model)
		model_node.rotation = rot
		print("Randomized Orientation for %s" % model_node.name)