extends CanvasLayer
class_name CharacterDebugCanvas


@export var state_template: String = "State : %s"
@onready var state: Label = %StateLabel

@export var hookshot_distance_template: String = "Hookshot Distance : %f"
@onready var hookshot_distance: Label = %HookshotDistance

@export var speedometer_template: String = "Speed :%03.3f\nVelocity : %03.3f:%03.3f:%03.3f"
@onready var speedometer: Label = %Speedometer


func set_state(value: String) -> void:
	state.text = state_template % value

func set_hookshot_distance(value: float) -> void:
	hookshot_distance.text = hookshot_distance_template % value

func set_speedometer(value: Vector3) -> void:
	speedometer.text = speedometer_template % [value.length(), value.x, value.y, value.z]
