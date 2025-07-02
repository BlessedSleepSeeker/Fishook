extends Node

var main_seed: String = ''

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#generate_seeds()

func generate_seeds():
	if (main_seed == ''):
		rng.randomize()
		rng.seed = hash(rng.randi())
		main_seed = str(rng.seed)
	else:
		rng.seed = int(main_seed)

func reset_seeds():
	main_seed = ''
	generate_seeds()