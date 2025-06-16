extends Resource
class_name AlgorithmRules

@export var grid: Array[AlgorithmTileGeneration] = []
var grid_size: Vector3i = Vector3i.ZERO

func _init():
	print_debug("Initiating Base Rules")

## Create each generation tiles (tiles only used for generating level, which are converted to 3D afterward)
func setup(_grid_size: Vector3i, _tiles: AlgorithmTiles) -> void:
	var total_positions: int = _grid_size.x * _grid_size.y * _grid_size.z
	print_debug("Generating grid : total size %d" % total_positions)
	grid_size = _grid_size
	for pos_x: int in _grid_size.x:
		for pos_y: int in _grid_size.y:
			for pos_z: int in _grid_size.z:
				var new_tile: AlgorithmTileGeneration = AlgorithmTileGeneration.new()
				new_tile.grid_position = Vector3i(pos_x, pos_y, pos_z)
				new_tile.available_tiles = _tiles.algorithm_tiles
				grid.append(new_tile)
	# print_debug("Generated grid size : %d" % grid.size())

func loop() -> void:
	pass

func get_next_tile() -> AlgorithmTileGeneration:
	return get_tile_from_position(find_next_tile_position())

func find_next_tile_position() -> Vector3i:
	return Vector3i.ZERO

func find_start_tile_position() -> Vector3i:
	return Vector3i.ZERO

func get_tile_from_position(position: Vector3i) -> AlgorithmTileGeneration:
	if not check_if_position_can_exist(position):
		push_error("Position %s does not exist" % position)
		return null
	for tile: AlgorithmTileGeneration in grid:
		if tile.grid_position == position:
			return tile
	push_error("Tile not found at position %s" % position)
	return null

func check_if_position_can_exist(position: Vector3i) -> bool:
	if position.x < 0 || position.x > grid_size.x - 1:
		return false
	if position.y < 0 || position.y > grid_size.y - 1:
		return false
	if position.z < 0 || position.z > grid_size.z - 1:
		return false
	return true

func check_for_respawn() -> bool:
	for tile: AlgorithmTileGeneration in self.grid:
		if tile.chosen_tile_definition.tile_name == "BasicRespawn":
			return true
	return false


func reset_generation() -> void:
	grid = []