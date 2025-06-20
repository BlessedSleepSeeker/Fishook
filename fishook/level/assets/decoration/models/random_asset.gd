extends Node3D
class_name RandomAsset

@export var asset_models: Array[PackedScene] = []
@export var random_rotation_values: RandomRotationValues = RandomRotationValues.new()

func randomize_asset() -> void:
	for child in get_children():
		child.queue_free()
	var index: int = RNGHandler.rng.randi_range(0, asset_models.size() - 1)
	var asset = asset_models[index].instantiate()
	add_child(asset)
	randomize_orientation(asset)

func randomize_orientation(asset: Node3D) -> void:
	var rot_x: float = RNGHandler.rng.randf_range(random_rotation_values.rotation_x_min, random_rotation_values.rotation_x_max)
	var rot_y: float = RNGHandler.rng.randf_range(random_rotation_values.rotation_y_min, random_rotation_values.rotation_y_max)
	var rot_z: float = RNGHandler.rng.randf_range(random_rotation_values.rotation_z_min, random_rotation_values.rotation_z_max)
	var rot: Vector3 = Vector3(rot_x, rot_y, rot_z)

	asset.rotation = rot

func _ready():
	randomize_asset()