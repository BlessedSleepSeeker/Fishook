extends CharacterBody3D
class_name CharacterInstance


@onready var state_machine: StateMachine = $StateMachine
@onready var model_container: Node3D = $"%ModelContainer"
@onready var hitbox: CollisionShape3D = $"%Hitbox"

var model_animation_player: AnimationPlayer = null

func _ready():
	get_model_anim_player()

func set_model(model: PackedScene) -> void:
	if model:
		var inst = model.instantiate()
		if inst.has_node("AnimationPlayer"):
			model_animation_player = inst.get_node("AnimationPlayer")
		model_container.add_child(inst)

func get_model_anim_player():
	for model in model_container.get_children():
		if model.has_node("AnimationPlayer"):
			model_animation_player = model.get_node("AnimationPlayer")

func transition_state(state_name: String, msg: Dictionary = {}):
	state_machine.transition_to(state_name, msg)

func has_state(state_name: String) -> bool:
	for state: CharacterState in state_machine.get_children():
		if state.name == state_name:
			return true
	return false

# func _physics_process(delta):
# 	print(velocity)

func play_animation(animation_name: String, reverse: bool = false):
	if model_animation_player == null:
		return
	if not model_animation_player.has_animation(animation_name):
		push_warning(DebugHelper.format_debug_string(self, "WARNING", "Missing Animation [%s]" % animation_name))
		return
	if not reverse:
		model_animation_player.play(animation_name)
	else:
		model_animation_player.play_backwards(animation_name)
	model_animation_player.advance(0)

func set_hitbox_shape(shape: Shape3D) -> void:
	hitbox.shape = shape
