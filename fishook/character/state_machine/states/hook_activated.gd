extends CharacterState
class_name HookActivatedState

@export var fishook_scene: PackedScene = preload("res://character/hookshot/HookshotFishook.tscn")
var fishook: Node3D = null

@export_group("Debug")
@export var spawn_debug: bool = false
@export var debug_ball: PackedScene = preload("res://debug/DebugBall.tscn")

@onready var reel_sound_player: AudioStreamPlayer = %ReelSoundPlayer

var hookshot_raycast: RayCast3D = null
var hookshot_point: Vector3 = Vector3.ZERO
var distance: float

var frame_nbr: int = 0

var can_reset_dj: bool = false

func enter(_msg := {}) -> void:
	super()
	## reset double jump
	hookshot_raycast = character.camera.raycast
	if hookshot_raycast.is_colliding():
		hookshot_point = hookshot_raycast.get_collision_point()
		distance = character.global_position.distance_to(hookshot_point)
		spawn_fishook()
	else:
		state_machine.transition_to("Fall")
		return
	character.skin.toggle_hookline(true, fishook)
	character.particles_manager.emit("HookTrail")
	if character.skin.animation_tree.active:
		character.skin.animation_tree.animation_finished.connect(play_animation)
	else:
		play_animation()

func unhandled_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Fall")


func physics_update(_delta: float, _move_character: bool = true):
	character.debug_canvas.set_hookshot_distance(distance)
	#var direction: Vector3 = character.global_position.direction_to(hookshot_point)
	super(_delta, false)
	if Input.is_action_pressed("reel_in"):
		reel_in(_delta)
	if Input.is_action_pressed("reel_out"):
		reel_out(_delta)


	if frame_nbr == 9:
		character.skin.swing_with_hookshot(character.velocity, character.velocity.length() * physics_parameters.GRAPPLE_ROTATION_SPEED, _delta)
		frame_nbr = 0
	else:
		frame_nbr += 1
	swing(_delta)

	## reset double jump only if you've gone downward once
	if character.velocity.y < 0:
		can_reset_dj = true
	if can_reset_dj && character.velocity.y > 0:
		character.did_double_jump = false
	character.move_and_slide()
	#character.skin.swing_with_hookshot(character.velocity, character.velocity.length() * physics_parameters.GRAPPLE_ROTATION_SPEED, _delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")

func swing(_delta: float) -> void:
	## No need to adjust movement if we are not outside of range !
	var current_distance = character.global_position.distance_to(hookshot_point)
	if current_distance < distance:
		return

	## Find the future position with current velocity
	var future_pos = character.global_position + (character.velocity * _delta)
	## Find the position where your character should be when being attached to the hookshot.
	var new_point = hookshot_point + (hookshot_point.direction_to(future_pos) * distance)
	## Update velocity to go in the direction of the new_point.
	character.velocity = (new_point - character.global_position) / _delta

	if spawn_debug:
		var inst: StaticBody3D = debug_ball.instantiate()
		add_child(inst)
		inst.global_position = new_point

func reel_in(_delta: float) -> void:
	var displacement = distance - physics_parameters.GRAPPLE_REST_LENGTH
	if displacement > 0:
		distance = character.global_position.distance_to(hookshot_point) - (physics_parameters.GRAPPLE_REELING_SPEED * _delta)
		if reel_sound_player.playing == false:
			reel_sound_player.play()

func reel_out(_delta: float) -> void:
	var displacement = physics_parameters.GRAPPLE_MAX_RANGE - distance
	if displacement > 0:
		distance = character.global_position.distance_to(hookshot_point) + (physics_parameters.GRAPPLE_REELING_SPEED * _delta)
		if reel_sound_player.playing == false:
			reel_sound_player.play()

func spawn_fishook() -> void:
	var inst = fishook_scene.instantiate()
	add_child(inst)
	inst.global_position = hookshot_point
	fishook = inst

func exit():
	character.particles_manager.stop("HookTrail")
	character.skin.animation_tree.animation_finished.disconnect(play_animation)
	if fishook:
		fishook.queue_free()
		fishook = null
	character.skin.toggle_hookline(false, null)
	character.skin.reset_swing_orientation()
