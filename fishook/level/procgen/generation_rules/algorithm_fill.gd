extends AlgorithmRules
class_name AlgorithmRulesFill

var current_pos_x: int = 0
var current_pos_y: int = 0
var current_pos_z: int = 0

func _init():
	print_debug("Initiating Fill Algorithm")

func find_next_tile_position() -> Vector3i:
	if current_pos_x >= grid_size.x - 1:
		current_pos_z += 1
		current_pos_x = 0
		if current_pos_z >= grid_size.z:
			current_pos_y += 1
			current_pos_z = 0
	else:
		current_pos_x += 1
	return Vector3i(current_pos_x, current_pos_y, current_pos_z)


func loop() -> void:
	for i: int in grid.size():
		var tile: AlgorithmTileGeneration = get_next_tile() if i != 0 else get_tile_from_position(find_start_tile_position())
		tile.pick_tile()
