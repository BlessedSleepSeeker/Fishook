extends Resource
class_name AlgorithmTileDefinition

@export_group("Tile Identity")
@export var tile_name: String = ""
@export_file("*.tscn") var scene_path: = ""

## The weight of the tile in randomization.
@export var generation_weight: int = -1
## Multiply the generation weight by the current tile height when randomizing for tile type.
## If at 1 == no change. If at 2 == double chance per height.
@export var generation_weight_height_multiplier: float = 1

## Represent allowed neighbors based on position offset.
## Keys represent the offset from current position, Values are the array of tiles which are allowed.

## WFC Sockets system
# 0 == empty space
# 1 == ground level tiles (16x1x16)
# 2 == full square tiles (16x16x16)

## extended range for socket_offset positions:
#Vector3i( 1,  0,  1): [], #north east
#Vector3i( 1,  0, -1): [], #north west
#Vector3i(-1,  0,  1): [], #south east
#Vector3i( 1,  0, -1): [], #south west

#Vector3i( 1,   1,  0): [], #north up
#Vector3i(-1,   1,  0): [], #south up
#Vector3i( 1,  -1,  0): [], #north down
#Vector3i(-1,  -1,  0): [], #south down

#Vector3i( 0,   1,  1): [], #east up
#Vector3i( 0,   1, -1): [], #west up
#Vector3i( 0,  -1,  1): [], #east down
#Vector3i( 0,  -1, -1): [], #west down

@export var can_be_rotated_horizontaly: bool = false
@export var rotation_score: int = 0

@export var tile_socket: int = 0

@export var sockets: Dictionary[Vector3i, Array] = {
	Vector3i( 1,  0,  0): [0, 1, 2, 3], #north
	Vector3i(-1,  0,  0): [0, 1, 2, 3], #south
	Vector3i( 0,  1,  0): [0, 1, 2, 3], #up
	Vector3i( 0, -1,  0): [0, 1, 2, 3], #down
	Vector3i( 0,  0,  1): [0, 1, 2, 3], #east
	Vector3i( 0,  0, -1): [0, 1, 2, 3], #west
}

## 0 = no change
## 1 = 90° west
## 2 = 180°
## 3 = 270° west
func rotate_sockets(new_orientation: int) -> void:
	var new_sockets: Dictionary[Vector3i, Array] = {}
	for socket: Vector3i in sockets:
		## Rotate the socket
		var new_socket: Vector3i = rotate_socket(socket, new_orientation)
		## Set the new socket as key with the old socket value
		new_sockets[new_socket] = sockets[socket]
	sockets = new_sockets


## Rotate a socket offset 90° to the west.
func rotate_socket(socket: Vector3i, amount: int) -> Vector3i:
	var new_vec: Vector3i = Vector3i.ZERO
	if amount == 1: ## 90° West
		new_vec.x = -socket.z
		new_vec.y = socket.y
		new_vec.z = -socket.x
	elif amount == 2: ## 180° (inversion)
		new_vec.x = socket.x * -1
		new_vec.y = socket.y
		new_vec.z = socket.z * -1
	elif amount == 3: ## 270° West or 90° East
		new_vec.x = socket.z
		new_vec.y = socket.y
		new_vec.z = socket.x

	return new_vec