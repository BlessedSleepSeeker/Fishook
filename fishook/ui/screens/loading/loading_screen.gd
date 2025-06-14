extends Control
class_name LoadingScreen

@export var animation_speed: float = 0.8
@export var bar_color_tweak_with_progress: Gradient = Gradient.new()

@export var bar_label_template: String = "[font_size=30][wave amp=40.0 freq=10 connected=1]%s[/wave][/font_size]"

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var bar_label: RichTextLabel = %BarLabel

func _ready():
	pass# await get_tree().create_timer(2).timeout
	# update_bar(23, "Collapsing Wave Function...")

	# await get_tree().create_timer(3).timeout
	# update_bar(82, "Rendering World...")

	# await get_tree().create_timer(1).timeout
	# update_bar(99.9, "Finishing Touches...")

func update_bar(amount: float, info: String) -> void:
	var tween_bar_progress: Tween = get_tree().create_tween()
	tween_bar_progress.tween_property(progress_bar, "value", amount, animation_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	var theme_box: StyleBoxFlat = progress_bar.theme.get_stylebox("fill", "ProgressBar")
	var tween_bar_bg_color: Tween = get_tree().create_tween()
	var color_: Color = bar_color_tweak_with_progress.sample(amount / 100)
	tween_bar_bg_color.tween_property(theme_box, "bg_color", color_, animation_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	var tween_label: Tween = get_tree().create_tween()
	tween_label.tween_property(bar_label, "text", bar_label_template % info, animation_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
