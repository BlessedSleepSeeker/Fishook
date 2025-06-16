extends Node3D
class_name AlgorithmTileScene

var tile_generation: AlgorithmTileGeneration = null

func get_debug_data() -> Dictionary[String, String]:
	var debug_data: Dictionary[String, String] = {}

	debug_data["tile_type"] = tile_generation.chosen_tile_definition.tile_name
	debug_data["grid_position"] = "%d:%d:%d" % [tile_generation.grid_position.x, tile_generation.grid_position.y, tile_generation.grid_position.z]

	return debug_data