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
