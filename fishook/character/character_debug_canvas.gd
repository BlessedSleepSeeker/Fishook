extends CanvasLayer
class_name CharacterDebugCanvas


@export var state_template: String = "State : %s"
@onready var state: Label = %StateLabel

@onready var hookshot_distance_template: String = "Hookshot Distance : %f"
@onready var hookshot_distance: Label = %HookshotDistance


func set_state(value: String) -> void:
	state.text = state_template % value

func set_hookshot_distance(value: float) -> void:
	hookshot_distance.text = hookshot_distance_template % value