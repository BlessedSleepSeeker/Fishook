extends Node3D
class_name CharacterSkin

@onready var animation_tree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")


func travel(state_name: String) -> void:
	state_machine.travel(state_name)
