extends Resource
class_name ProceduralLevelAlgorithm

@export_group("Generation Values")
## The Main Seed used for random generation
@export var generation_seed: String = ""

## Define the maximum amount of tiles on the X (north/south), Y (up/down) and Z (east/west) axis 
@export var grid_size: Vector3i = Vector3i(30, 5, 30)
@export var tile_size: Vector3i = Vector3i(16, 16, 16)

@export_group("Generation Childs")
## The tiles used for generation
@export var tiles: AlgorithmTiles = null
## The actual algorithm rules used for generation
@export var rules: AlgorithmRules = null

func _init():
	print_debug("Initiating Procedural Generation Algorithm")

func setup() -> void:
	tiles.preload_tiles_scenes()
	rules.setup(grid_size, tiles)
	setup_rng()

func setup_rng():
	RNGHandler.MAIN_SEED = generation_seed
	RNGHandler.generate_seeds()

func generate_grid() -> void:
	rules.loop()

func load_grid_into_world(parent: Node3D) -> void:
	for tile: AlgorithmTileGeneration in rules.grid:
		var instance = tiles.get_tile_instance(tile.chosen_tile_definition.tile_name)
		parent.add_child(instance)
		instance.position = tile.grid_position * tile_size

func clean() -> void:
	rules = null
	tiles = null
