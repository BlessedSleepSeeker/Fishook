extends BaseLevel
class_name ProceduralLevel

@onready var geometry_parent: Node3D = $Geometry
@export var algorithm: ProceduralLevelAlgorithm = null

func _ready():
	algorithm.setup()
	algorithm.generate_grid()
	algorithm.load_grid_into_world(geometry_parent)
	super()
