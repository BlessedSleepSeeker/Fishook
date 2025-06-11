## Represent a placed tile in the world during the algorithm generation phase.
extends Resource
class_name AlgorithmTileGeneration

@export_group("Generation Helpers")
@export var grid_position: Vector3i = Vector3i(0, 0, 0)

@export var chosen_tile_definition: AlgorithmTileDefinition = null

@export var available_tiles: Array[AlgorithmTileDefinition]
var entropy_score: int:
	get():
		return available_tiles.size()

## Removing an option return an array of position offsets of neighbors. This will be used for repercuting options 
func remove_option(tile_definition: AlgorithmTileDefinition) -> Array[Vector3i]:
	if available_tiles.has(tile_definition):
		available_tiles.remove_at(available_tiles.find(tile_definition))
		
	return []

## TODO : CHANGE TO WEIGHTED RNG
func pick_tile() -> void:
	#print("Picking for %s" % grid_position)
	if available_tiles.size() == 1:
		return available_tiles.front()
	if available_tiles.size() == 0:
		push_error("No tiles available at position %s (this shouldn't happen !)" % grid_position)
		return
	weighted_random_pick()
	#print("Picked %s" % [chosen_tile_definition.tile_id])


func weighted_random_pick() -> void:
	var sum = 0
	for tile: AlgorithmTileDefinition in available_tiles:
		sum += tile.generation_weight
	var rng_nbr: int = RNGHandler.rng.randi_range(0, sum)
	for tile: AlgorithmTileDefinition in available_tiles:
		if rng_nbr <= tile.generation_weight:
			chosen_tile_definition = tile
			return
		rng_nbr -= tile.generation_weight
