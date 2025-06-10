## Represent a placed tile in the world during the algorithm generation phase.
extends Resource
class_name ProceduralLevelTileGeneration

@export var tile_definition: ProceduralLevelTileDefinition = ProceduralLevelTileDefinition.new()

@export var grid_pos_x: int = -1
@export var grid_pos_y: int = -1
@export var grid_pos_z: int = -1