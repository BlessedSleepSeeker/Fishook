extends Resource
class_name ProceduralLevelTileDefinition

@export var tile_id: String = ""
@export_file("*.tscn") var scene_path: = ""

@export var generation_weight: int = -1
## If true, check for allowed neighbor. If false, check for forbidden neighbors
@export var allowed_or_forbidden: bool = true

@export var neighbor_north: Array[String] = []
@export var neighbor_south: Array[String] = []
@export var neighbor_east: Array[String] = []
@export var neighbor_west: Array[String] = []
@export var neighbor_up: Array[String] = []
@export var neighbor_down: Array[String] = []