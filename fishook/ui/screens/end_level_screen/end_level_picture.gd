extends TextureRect
class_name EndLevelPicture

@export_range(-180, 180, 1) var min_rotation: float = -45
@export_range(-180, 180, 1) var max_rotation: float = 45


@onready var shader_rect: ColorRect = %ShaderHolder
@onready var shader_material: ShaderMaterial = shader_rect.material

func add_texture(_texture: ImageTexture) -> void:
	self.texture = _texture
	if self.texture == null:
		push_error("Can't create EndLevelPicture, texture is null")
	randomize_rotation()
	shader_rect.size = _texture.get_size()
	tween_shader_param("Alpha", 0, 1.5)

func randomize_rotation() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	self.rotation_degrees = rng.randf_range(min_rotation, max_rotation)

func tween_shader_param(parameter_name: String, tween_value: Variant, tween_speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/%s" % parameter_name, tween_value, tween_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
