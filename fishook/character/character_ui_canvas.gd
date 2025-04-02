extends CanvasLayer
class_name CharacterHUD

@onready var crosshair_container: Container = %CrosshairContainer

@onready var crosshair: TextureRect = %Crosshair
@onready var collision_crosshair: TextureRect = %CollisionCrosshair
@onready var double_jump_indicator: TextureRect = %DoubleJumpIndicator

@onready var bullet_time_indicator: TextureRect = %BulletTimeIndicator
@onready var bullet_time_screen_fx: ColorRect = %BulletTimeVFX

@export_group("Crosshair")
@export var crosshair_base_texture: Texture2D = preload("res://character/ui_assets/PNG/Outline/crosshair009.png")
@export var crosshair_base_color: Color = Color("ffffff")
@export var crosshair_color_on_colliding: Color = Color("70ff7c")

@onready var settings: Settings = get_tree().root.get_node("Root").settings

func set_double_jump_base_color(new_color: Color) -> void:
	double_jump_indicator.modulate = new_color

func set_double_jump_cooldown_color(new_color: Color) -> void:
	double_jump_indicator.material.set_shader_parameter("cooldown_color", new_color)

func set_double_jump_current_cooldown(remaining_time: float, max_time: float) -> void:
	var percent: float = remaining_time / max_time
	double_jump_indicator.material.set_shader_parameter("percent", percent)

func tween_double_jump_cooldown(wanted_time: float, max_time: float, tween_speed: float) -> void:
	var percent: float = wanted_time / max_time
	var tween: Tween = get_tree().create_tween()

	tween.tween_property(double_jump_indicator.material, "shader_parameter/percent", percent, tween_speed)

func crosshair_collision(is_colliding: bool) -> void:
	var tween_container: Tween = get_tree().create_tween()
	var tween_collision: Tween = get_tree().create_tween()
	if is_colliding:
		tween_container.tween_property(crosshair_container, "modulate", crosshair_color_on_colliding, 0.1).set_ease(Tween.EASE_OUT)
		tween_collision.tween_property(collision_crosshair, "modulate:a", 1, 0.1).set_ease(Tween.EASE_OUT)
	else:
		tween_container.tween_property(crosshair_container, "modulate", crosshair_base_color, 0.1).set_ease(Tween.EASE_OUT)
		tween_collision.tween_property(collision_crosshair, "modulate:a", 0, 0.1).set_ease(Tween.EASE_OUT)

func fade_crosshair(direction: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	if direction:
		tween.tween_property(crosshair, "modulate:a", 1, 0.1).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(crosshair, "modulate:a", 0, 0.1).set_ease(Tween.EASE_OUT)

func change_crosshair_to(crosshair_texture: Texture2D) -> void:
	if crosshair_texture:
		crosshair.texture = crosshair_texture
	else:
		if crosshair.texture != crosshair_base_texture:
			crosshair.texture = crosshair_base_texture

func tween_bullet_time(wanted_time: float, max_time: float, tween_speed: float):
	if settings.read_setting_value_by_key("DISABLE_BULLET_TIME_VISUALS"):
		return
	var percent: float = wanted_time / max_time
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(bullet_time_screen_fx.material, "shader_parameter/levels", clampi(int(percent) * 10, 3, 10), tween_speed)
	var tween3: Tween = get_tree().create_tween()
	tween3.tween_property(bullet_time_screen_fx, "modulate:a", inverse_number_around_another(percent, 0.5), tween_speed)


	var tween2: Tween = get_tree().create_tween()
	tween2.tween_property(bullet_time_indicator.material, "shader_parameter/percent", percent, tween_speed)
	#tween2.tween_property(bullet_time_screen_fx, "modulate:a", alpha_clamp, tween_speed)


static func inverse_number_around_another(number: float, axis: float) -> float:
	return axis - (number - axis)
