extends Control
class_name ClientSettingsUI

@export var setting_tab_scene: PackedScene = preload("res://ui/screens/settings/setting_tab.tscn")

@export var back_scene_path: String = "res://ui/screens/main_menu/main_menu.tscn"
@export var transition_on_back: bool = true
@export var emit_signal_on_back: bool = true

@onready var settings_tab: TabContainer = $MC/VB/SettingsTab
@onready var settings: Settings = get_tree().root.get_node("Root").settings

@onready var save_dialog: ConfirmationDialog = $SaveDialog
@onready var quit_dialog: ConfirmationDialog = $QuitDialog
@onready var save_btn: Button = %SaveButton

signal going_back
signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	for section in settings.get_sections_list():
		var instance: SettingsTab = setting_tab_scene.instantiate()
		settings_tab.add_child(instance)
		instance.settings = settings.get_settings_by_section(section)
		instance.section_name = section
	save_dialog.confirmed.connect(_on_save_confirmed)
	quit_dialog.confirmed.connect(_on_quit_confirmed)
	save_btn.grab_focus()

func _on_quit_button_pressed():
	var b = false
	for tabs: SettingsTab in settings_tab.get_children():
		if tabs.has_modified_settings():
			quit_dialog.show()
			b = true
	if not b:
		go_back()
	

func _on_save_button_pressed():
	save_dialog.show()


func _on_save_confirmed():
	for tabs: SettingsTab in settings_tab.get_children():
		tabs.save()
	settings.apply_settings()
	settings.save_settings_to_file()
	InputHandler.save_actions_to_file()


func _on_quit_confirmed():
	go_back()

func go_back() -> void:
	if emit_signal_on_back:
		going_back.emit()
	if transition_on_back:
		transition_by_path.emit(back_scene_path, {}, false, "transition")
