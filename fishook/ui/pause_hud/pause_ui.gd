extends Control
class_name PauseUI

@onready var continue_btn: Button = %Continue
@onready var settings_btn: Button = %Settings

signal continue_game
signal go_to_settings
signal go_to_level_selector
signal go_to_main_menu

func _on_continue_pressed():
	continue_game.emit()

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
