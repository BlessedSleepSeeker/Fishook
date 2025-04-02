extends Control
class_name LevelSelectButton

@export var level_data: LevelData = LevelData.new():
	set(value):
		level_data = value
		update_button()

@onready var button: Button = %Button

signal pressed(level: LevelData)

func _ready():
	button.pressed.connect(on_button_pressed)
	update_button()

func update_button() -> void:
	button.text = level_data.name

func on_button_pressed() -> void:
	self.button.disabled = true
	pressed.emit(level_data)
