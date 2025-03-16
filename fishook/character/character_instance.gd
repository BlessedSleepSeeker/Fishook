extends CharacterBody3D
class_name CharacterInstance


@onready var state_machine: StateMachine = $StateMachine
@onready var skin: CharacterSkin = %CharacterSkin
@onready var camera: MouseFollowCamera = $MouseFollowCamera
@onready var hitbox: CollisionShape3D = %Hitbox
@onready var particles_manager: ParticlesManager = %ParticlesManager

var direction: Vector3 = Vector3.ZERO
var raw_input: Vector2 = Vector2.ZERO
var  last_movement_direction: Vector3 = Vector3.BACK

var did_double_jump: bool = false

func _ready():
	pass

func transition_state(state_name: String, msg: Dictionary = {}):
	state_machine.transition_to(state_name, msg)

func has_state(state_name: String) -> bool:
	for state: CharacterState in state_machine.get_children():
		if state.name == state_name:
			return true
	return false

func play_animation(animation_name: String):
	if skin == null:
		return
	skin.travel(animation_name)

func set_hitbox_shape(shape: Shape3D) -> void:
	hitbox.shape = shape

## TODO : should be moved at some point in another code
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE