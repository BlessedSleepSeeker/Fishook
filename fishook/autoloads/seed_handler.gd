extends Node

signal main_seed_changed(new_value: String)

var MAIN_SEED: String = '':
	set(value):
		print("main_seed:", MAIN_SEED)
		if value != '':
			main_seed_changed.emit(value)
			MAIN_SEED = value

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#generate_seeds()

func generate_seeds():
	if (MAIN_SEED == ''):
		rng.randomize()
		rng.seed = hash(rng.randi())
		MAIN_SEED = str(rng.seed)
	else:
		rng.seed = int(MAIN_SEED)

func reset_seeds():
	MAIN_SEED = ''
	generate_seeds()