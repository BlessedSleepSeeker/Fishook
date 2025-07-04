extends Control

@export_file(".tscn") var mainMenuPath: String = "res://ui/screens/main_menu/main_menu.tscn"
@export_multiline var credit_template: String = ""

@onready var credit_lbl: RichTextLabel = %RichTextLabel
@onready var return_btn: Button = %ReturnButton

signal transition_by_path(new_scene_path: String, scene_parameters: Dictionary, toggle_loading_screen: bool, animation: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	return_btn.grab_focus()
	pass # Replace with function body.

func _on_button_pressed():
	transition_by_path.emit(mainMenuPath, {}, false, "transition")


func build_credits() -> void:
	var localized_credits: String = credit_template % [tr("CREDIT_STUDIO_NAME"), tr("CREDIT_DEV_NAME"), tr("CREDIT_EXT_ASSET_TITLE"), tr("CREDIT_EXT_ASSET1"), tr("CREDIT_EXT_ASSET2"), tr("CREDIT_EXT_ASSET3"), tr("CREDIT_EXT_SHADER_LINK")]
	credit_lbl.text = localized_credits


func _notification(what):
	if what == Node.NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready # Wait until ready signal.
		build_credits()