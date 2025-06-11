extends Resource
class_name AlgorithmTileDefinition

@export_group("Tile Identity")
@export var tile_id: String = ""
@export_file("*.tscn") var scene_path: = ""

## The weight of the tile in randomization.
@export var generation_weight: int = -1

## Represent allowed neighbors based on position offset.
## Keys represent the offset from current position, Values are the array of tiles which are allowed.
@export var allowed_neighbors: Dictionary[Vector3i, Array] = {
	Vector3i(1, 0, 0): ["air", "basic_ground", "stairs"], #north
	Vector3i(-1, 0, 0): ["air", "basic_ground", "stairs"], #south
	Vector3i(0, 1, 0): ["air", "basic_ground", "stairs"], #up
	Vector3i(0, -1, 0): ["air", "basic_ground", "stairs"], #down
	Vector3i(0, 0, 1): ["air", "basic_ground", "stairs"], #east
	Vector3i(0, 0, -1): ["air", "basic_ground", "stairs"], #west
}