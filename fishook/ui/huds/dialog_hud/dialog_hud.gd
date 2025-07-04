extends CanvasLayer
class_name DialogHUD

@export var show_hide_speed: float = 0.3
@export var translate_dialog: bool = true
var untranslated_text: String = ""


@onready var dialog_panel: PanelContainer = %DialogPanel
@onready var dialog_label: PlayerControlLabel = %PlayerControlLabel
@onready var top_container: Container = %TopContainer

func _ready():
	top_container.modulate.a = 0
	animate_dialog_box()

func update_dialog(new_text: String, hide_after: float = -1, use_letter_by_letter: bool = false) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(top_container, "modulate:a", 1, show_hide_speed)
	untranslated_text = new_text
	new_text = LanguageHandler.translate_rich(new_text) if translate_dialog else new_text
	dialog_label.update_text(new_text, true, use_letter_by_letter)
	if hide_after >= 0:
		dialog_label.all_text_displayed.connect(delay_hide.bind(hide_after), CONNECT_ONE_SHOT)

func delay_hide(delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	hide_dialog()

func hide_dialog() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(top_container, "modulate:a", 0, show_hide_speed)

func animate_dialog_box(forward: bool = true) -> void:
	var tween: Tween = get_tree().create_tween()
	var theme_box: StyleBoxFlat = dialog_panel.theme.get_stylebox("panel", "PanelContainer")
	var color_: Color = Color("00cccc") if forward else Color("cc00be")
	tween.tween_property(theme_box, "border_color", color_, 10)
	tween.finished.connect(animate_dialog_box.bind(!forward))

func get_dialog_text() -> String:
	return dialog_label.text

func is_text_currently_displayed(text: String) -> bool:
	return untranslated_text == text


func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		var new_text: String = LanguageHandler.translate_rich(untranslated_text) if translate_dialog else untranslated_text
		dialog_label.update_text(new_text)
