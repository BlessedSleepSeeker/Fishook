extends Resource
class_name ProceduralLevelAlgorithm

@export_group("Generation Values")
## The Main Seed used for random generation
@export var generation_seed: String = ""

## Define the maximum amount of tiles on the X axis (north/south)
@export var x_grid_size: int = 30
## Define the maximum amount of tiles on the Y axis (up/down)
@export var y_grid_size: int = 5
## Define the maximum amount of tiles on the Z axis (west/east)
@export var z_grid_size: int = 30
@export var max_tiles: int = x_grid_size * y_grid_size * z_grid_size

@export_group("Generation Childs")
@export var tiles: ProceduralLevelAlgorithmTiles = ProceduralLevelAlgorithmTiles.new()
@export var rules: ProceduralLevelAlgorithmRules = ProceduralLevelAlgorithmRules.new()