extends MarginContainer
class_name SettingsTab

@export var setting_line_scene: PackedScene = preload("res://ui/screens/settings/settings_line.tscn")
@export var section_name: String:
	set(val):
		section_name = val
		self.name = section_name

@onready var column: VBoxContainer = $SC/VB

@export var settings: Array = []:
	set(val):
		settings = val
		build_settings_ui()


func build_settings_ui() -> void:
	for setting in settings:
		var instance: SettingLine = setting_line_scene.instantiate()
		column.add_child(instance)
		instance.setting = setting
		if setting != settings[-1]:
			var separator: HSeparator = HSeparator.new()
			separator.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			column.add_child(separator)


func has_modified_settings() -> bool:
	for child in column.get_children():
		if child is SettingLine:
			if child.is_modified():
				return true
	return false

func save() -> void:
	for child in column.get_children():
		if child is SettingLine:
			child.save()
