extends CharacterState
class_name HookActivate

func enter(_msg := {}) -> void:
	if character.model_animation_player && loop_anim:
		character.model_animation_player.animation_finished.connect(play_animation)
	play_animation()
