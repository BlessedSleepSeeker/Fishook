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

func swing_with_hookshot(velocity: Vector3, rotation_speed: float, _delta: float) -> void:
	var node: Node3D = Node3D.new()
	if velocity != Vector3.ZERO:
		node.look_at_from_position(self.global_position, global_transform.origin + velocity, Vector3.MODEL_TOP, true)
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", node.rotation, rotation_speed * _delta)

func reset_swing_orientation() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation:x", 0, 1)