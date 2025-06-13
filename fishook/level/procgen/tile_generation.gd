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

## TODO : CHANGE TO WEIGHTED RNG
func pick_tile() -> void:
	#print("Picking for %s" % grid_position)
	if available_tiles.size() == 1:
		chosen_tile_definition = available_tiles.front()
		return
	if available_tiles.size() == 0:
		push_error("No tiles available at position %s (this shouldn't happen !)" % grid_position)
		return
	weighted_random_pick()


func weighted_random_pick() -> void:
	var sum = 0
	for tile: AlgorithmTileDefinition in available_tiles:
		sum += get_tile_weight(tile)
	var rng_nbr: float = RNGHandler.rng.randf_range(0, sum)
	for tile: AlgorithmTileDefinition in available_tiles:
		if rng_nbr <= get_tile_weight(tile):
			chosen_tile_definition = tile
			return
		rng_nbr -= get_tile_weight(tile)

func get_tile_weight(tile: AlgorithmTileDefinition) -> float:
	return tile.generation_weight * (tile.generation_weight_height_multiplier ** (grid_position.y))


#region Wave Function Collapse Functions

func collapse() -> Dictionary[Vector3i, Array]:
	pick_tile()
	#print("Collapsed tile %s for %s" % [grid_position, chosen_tile_definition.tile_name])
	return chosen_tile_definition.sockets

#endregion
