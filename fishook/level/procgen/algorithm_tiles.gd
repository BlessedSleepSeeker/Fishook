extends Resource
class_name AlgorithmTiles

@export var algorithm_tiles: Array[AlgorithmTileDefinition] = []

var tiles_scenes: Dictionary[String, PackedScene]

func preload_tiles_scenes() -> void:
	for tile: AlgorithmTileDefinition in algorithm_tiles:
		tiles_scenes[tile.tile_name] = load(tile.scene_path)

func get_tile_instance(tile_name: String) -> AlgorithmTileScene:
	return tiles_scenes[tile_name].instantiate()


func rotate_tiles():
	var rotated_tiles: Array[AlgorithmTileDefinition] = []
	for tile: AlgorithmTileDefinition in algorithm_tiles:
		if tile.can_be_rotated_horizontaly:
			for i in range(1, 4):
				var new_def: AlgorithmTileDefinition = tile.duplicate(true)
				new_def.rotate_sockets(i)
				new_def.rotation_score = i
				#new_def.tile_name += "_rotate_%d" % i
				rotated_tiles.append(new_def)
				# print(new_def.tile_name)
				# print(tile.sockets)
				# print(new_def.sockets)
		else:
			# To compensate for increased amount of rotated tile, which all have the original tile weight, we multiply the "single" tile's weight by 4
			tile.generation_weight *= 4
	algorithm_tiles.append_array(rotated_tiles)
