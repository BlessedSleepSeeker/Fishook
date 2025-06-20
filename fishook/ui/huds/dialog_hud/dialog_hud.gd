extends CanvasLayer
class_name DialogHUD

@onready var dialog_panel: PanelContainer = %DialogPanel
@onready var dialog_label: WordByWordLabel = %WordByWordLabel

func _ready():
	animate_dialog_box()

func update_dialog(new_text: String) -> void:
	self.show()
	dialog_label.update_dialog(new_text, true)


func animate_dialog_box(forward: bool = true) -> void:
	var tween: Tween = get_tree().create_tween()
	var theme_box: StyleBoxFlat = dialog_panel.theme.get_stylebox("panel", "PanelContainer")
	var color_: Color = Color("00cccc") if forward else Color("cc00be")
	tween.tween_property(theme_box, "border_color", color_, 10)
	tween.finished.connect(animate_dialog_box.bind(!forward))
