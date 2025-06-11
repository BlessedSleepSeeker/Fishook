extends Resource
class_name AlgorithmTiles

@export var algorithm_tiles: Array[AlgorithmTileDefinition] = []

var tiles_scenes: Dictionary[String, PackedScene]

func preload_tiles_scenes() -> void:
	for tile: AlgorithmTileDefinition in algorithm_tiles:
		tiles_scenes[tile.tile_id] = load(tile.scene_path)

func get_tile_instance(tile_id: String) -> AlgorithmTileScene:
	return tiles_scenes[tile_id].instantiate()