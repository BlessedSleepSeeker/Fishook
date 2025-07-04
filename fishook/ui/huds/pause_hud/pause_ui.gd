extends Control
class_name PauseUI

@onready var continue_btn: Button = %Continue
@onready var settings_btn: Button = %Settings
@onready var restart_btn: Button = %Restart
@onready var level_data_display: LevelDataDisplay = %LevelDataDisplay

signal continue_game
signal go_to_settings
signal go_to_level_selector
signal go_to_main_menu
signal restart

func build_data_display(level_data: LevelData) -> void:
	level_data_display.level_data = level_data

func _on_continue_pressed():
	continue_game.emit(false)

func _on_settings_pressed():
	go_to_settings.emit()

func _on_change_level_pressed():
	go_to_level_selector.emit()

func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	go_to_main_menu.emit()

func _on_visibility_changed():
	if self.visible && continue_btn:
		continue_btn.grab_focus()


func _on_restart_pressed():
	restart_btn.disabled = true
	restart.emit()


func tween_ui_visibility(direction: int, time: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", direction, time)

	await tween.finished