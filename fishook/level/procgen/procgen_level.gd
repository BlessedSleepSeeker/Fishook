extends BaseLevel
class_name ProceduralLevel

@export var algorithm: ProceduralLevelAlgorithm = null

@export var chunk_generating: bool = true
@export var chunk_loading: bool = true

@onready var geometry_parent: Node3D = $Geometry

var current_tile: AlgorithmTileScene = null

func _ready():
	generate_full_level()

func generate_full_level() -> void:
	algorithm.setup()
	algorithm.generate_full_grid()
	if not algorithm.check_grid_validity():
		print("Seed %s did not generate a valid level... Changing seed to random..." % RNGHandler.main_seed)
		RNGHandler.reset_seeds()
		algorithm.reset_generation()
		return generate_full_level()
	algorithm.load_grid_into_world(geometry_parent)
	algorithm.add_decorations(geometry_parent)
	algorithm.clean()
	debug_canvas.set_seed(RNGHandler.main_seed)
	super._ready()

func generate_chunk() -> void:
	pass


func load_chunk_to_world() -> void:
	pass

func _physics_process(delta):
	super(delta)
	if debug_canvas.visible:
		get_current_tile_debug_data()

func get_current_tile_debug_data() -> void:
	var tile: AlgorithmTileScene = get_tile_from_position(character.position)
	if tile != null:
		if current_tile == null:
			current_tile = tile
			debug_canvas.set_tile_infos(tile.get_debug_data())
		elif tile.position != current_tile.position:
			current_tile = tile
			debug_canvas.set_tile_infos(tile.get_debug_data())


func get_tile_from_position(world_position: Vector3) -> AlgorithmTileScene:
	for tile: AlgorithmTileScene in geometry_parent.get_children():
		if (world_position.x >= tile.position.x - (algorithm.tile_size.x / 2.0)  && world_position.x < tile.position.x + (algorithm.tile_size.x / 2.0)) && (world_position.y >= tile.position.y - algorithm.tile_size.y && world_position.y < tile.position.y + algorithm.tile_size.y) && (world_position.z >= tile.position.z - (algorithm.tile_size.z / 2.0) && world_position.z < tile.position.z + (algorithm.tile_size.z / 2.0)):
			return tile
	return null
