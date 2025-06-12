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
		var allowed_option_at_offset = allowed_options[offset]
		var tested_tile_position: Vector3i = offset + origin_position
		if check_if_position_can_exist(tested_tile_position):
			var tested_tile: AlgorithmTileGeneration = get_tile_from_position(tested_tile_position)
			# No need to iterate if the tile is chosen already.
			if tested_tile.chosen_tile_definition == null:
				remove_impossible_combination(tested_tile, allowed_option_at_offset)

## Takes a tile and allowed options for this specific tile, then remove disallowed options, creating a chain reaction.
func remove_impossible_combination(tile: AlgorithmTileGeneration, allowed_options: Array) -> void:
	var new_available_definitions: Array[AlgorithmTileDefinition] = []
	for tile_definition: AlgorithmTileDefinition in tile.available_tiles:
		if allowed_options.has(tile_definition.tile_id):
			new_available_definitions.append(tile_definition)
		else:
			print("Tile %s can't have a %s. Removing option" % [tile.grid_position, tile_definition.tile_id])
	tile.available_tiles = new_available_definitions
	## This is where the recursivity take place. We call the original function from the new position with the current removed option.
	#remove_options_to_offsets(tile.grid_position, tile_definition.allowed_neighbors)

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
		print("Collapsing at %s" % lowest_entropy_tile.grid_position)
		collapse_tile(lowest_entropy_tile)
