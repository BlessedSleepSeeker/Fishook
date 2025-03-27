extends Node3D
class_name CharacterSkin

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var hookline: HookshotLine = %HookshotLine

func _ready():
	hookline.hide()

func travel(state_name: String) -> void:
	state_machine.travel(state_name)

func toggle_hookline(toggled: bool, point: Node3D) -> void:
	if toggled:
		hookline.fishook = point
		hookline.reset()
		hookline.show()
	else:
		hookline.hide()

func swing_with_hookshot(hookshot_point: Vector3, rotation_speed: float, _delta: float) -> void:
	#var target_angle_x = global_position.signed_angle_to(hookshot_point, Vector3.UP) * 10

	# print(target_angle_x)
	#global_rotation.x = lerp_angle(global_rotation.x, target_angle_x, rotation_speed * _delta)

	# var target_angle_y: float = global_position.signed_angle_to(hookshot_point, Vector3.UP)
	# global_rotation.y = lerp_angle(rotation.y, target_angle_y, rotation_speed * _delta)
	#var tween: Tween = get_tree().create_tween()
	#tween.tween_method(self.look_at.bind(Vector3.MODEL_TOP, true), global_transform.origin, global_transform.origin + hookshot_point, rotation_speed * _delta)
	var node: Node3D = Node3D.new()
	node.look_at_from_position(self.global_position, global_transform.origin + hookshot_point, Vector3.MODEL_TOP, true)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", node.rotation, rotation_speed * _delta)

	#self.rotation.y = self.rotation.y * -1
	#self.rotation.z = self.rotation.z * -1

func reset_swing_orientation() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation:x", 0, 1)