extends CanvasLayer
class_name DebugCanvas


@export var state_template: String = "Character State : %s"
@onready var state: Label = %StateLabel

@export var hookshot_distance_template: String = "Hookshot Distance : %f"
@onready var hookshot_distance: Label = %HookshotDistance

@export var speedometer_template: String = "Character Speed :%03.3f\nVelocity : %03.3f:%03.3f:%03.3f"
@onready var speedometer: Label = %Speedometer

@export var world_position_template: String = "Character Position : [%.2f:%.2f:%.2f]"
@onready var world_position: Label = %WorldPosition

@export var tile_name_template: String = "Current Tile : %s"
@onready var tile_name: Label = %CurrentTileName

@export var tile_grid_position_template: String = "Current Tile Grid Position : [%s]"
@onready var tile_grid_position: Label = %CurrentTileGridPosition

func set_state(value: String) -> void:
	state.text = state_template % value

func set_hookshot_distance(value: float) -> void:
	hookshot_distance.text = hookshot_distance_template % value

func set_speedometer(value: Vector3) -> void:
	speedometer.text = speedometer_template % [value.length(), value.x, value.y, value.z]

func set_world_position(value: Vector3) -> void:
	world_position.text = world_position_template % [value.x, value.y, value.z]


func set_tile_infos(tile_infos: Dictionary[String, String]) -> void:
	tile_name.text = tile_name_template % tile_infos["tile_type"]
	tile_grid_position.text = tile_grid_position_template % tile_infos["grid_position"]