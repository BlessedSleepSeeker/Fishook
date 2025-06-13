extends AlgorithmRules
class_name AlgorithmRulesWaveFunctionCollapse

func _init():
	print_debug("Initiating Wave Function Collapse Algorithm")

## Check if at least one tile is not collapsed yet
func has_uncollapsed_tiles() -> bool:
	for tile: AlgorithmTileGeneration in grid:
		if tile.chosen_tile_definition == null:
			return true
	return false

func collapse_tile(tile: AlgorithmTileGeneration) -> void:
	var allowed_options = tile.collapse()
	remove_options_to_offsets(tile.grid_position, allowed_options)

func remove_options_to_offsets(origin_position: Vector3i, allowed_options: Dictionary[Vector3i, Array]) -> void:
	for offset: Vector3i in allowed_options:
		var tested_tile_position: Vector3i = offset + origin_position
		if check_if_position_can_exist(tested_tile_position):
			var tested_tile: AlgorithmTileGeneration = get_tile_from_position(tested_tile_position)
			# No need to iterate if the tile is chosen already.
			if tested_tile.chosen_tile_definition == null:
				remove_impossible_combination(tested_tile, allowed_options[offset])

## Takes a tile and allowed options for this specific tile, then remove disallowed options, creating a chain reaction.
func remove_impossible_combination(tile: AlgorithmTileGeneration, allowed_options: Array) -> void:
	var new_available_definitions: Array[AlgorithmTileDefinition] = []
	for tile_definition: AlgorithmTileDefinition in tile.available_tiles:
		#var inversed_socket: Vector3i = offset * -1
		if allowed_options.has(tile_definition.tile_socket):
			new_available_definitions.append(tile_definition)
		# else:
		# 	print("Tile %s can't have a %s. Removing option" % [tile.grid_position, tile_definition.tile_name])
	if tile.available_tiles != new_available_definitions:
		tile.available_tiles = new_available_definitions
		## This is where the recursivity take place. We call the original function from the new position with the current removed option.
		var aggregated_options: Dictionary[Vector3i, Array] = aggregate_potential_options(tile.available_tiles)
		remove_options_to_offsets(tile.grid_position, aggregated_options)

# func check_sockets_matching(sockets: Array, reverse_sockets: Array) -> bool:
# 	print(sockets)
# 	print(reverse_sockets)
# 	for allowed_socket in sockets:
# 		if reverse_sockets.has(allowed_socket):
# 			print("match !")
# 			return true
# 	print("not a match...")
# 	return false

func aggregate_potential_options(available_tiles: Array) -> Dictionary[Vector3i, Array]:
	var aggregated: Dictionary[Vector3i, Array] = {}
	for tile_definition: AlgorithmTileDefinition in available_tiles:
		for option_offset: Vector3i in tile_definition.sockets:
			if aggregated.has(option_offset):
				aggregated[option_offset].append_array(tile_definition.sockets[option_offset])
			else:
				aggregated[option_offset] = tile_definition.sockets[option_offset].duplicate()
	for keys in aggregated:
		aggregated[keys] = reduce_array_to_unique(aggregated[keys])
	return aggregated

func reduce_array_to_unique(original_array: Array) -> Array:
	var unique_array: Array = []
	for data in original_array:
		if not unique_array.has(data):
			unique_array.append(data)
	return unique_array

## Find the lowest entropy tile. Select one at random if multiples.
func get_next_tile() -> AlgorithmTileGeneration:
	var lowest_entropy_tiles: Array[AlgorithmTileGeneration] = []
	var lowest_entropy_score: int = 9223372036854775807 ## set up at max int
	for tile: AlgorithmTileGeneration in grid:
		## If the tile type has already been chosen, no need to check for it.
		if tile.chosen_tile_definition == null:
			if tile.entropy_score == lowest_entropy_score:
				lowest_entropy_tiles.append(tile)
			if tile.entropy_score < lowest_entropy_score:
				lowest_entropy_score = tile.entropy_score
				lowest_entropy_tiles.clear()
				lowest_entropy_tiles.append(tile)
	if lowest_entropy_tiles.size() <= 0:
		push_error("No low entropy tiles found")
		return null
	var rng_index = RNGHandler.rng.randi_range(0, lowest_entropy_tiles.size() - 1)
	return lowest_entropy_tiles[rng_index]

func loop() -> void:
	while(has_uncollapsed_tiles()):
		var lowest_entropy_tile: AlgorithmTileGeneration = get_next_tile()
		collapse_tile(lowest_entropy_tile)
