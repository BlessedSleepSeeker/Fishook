extends CharacterState

func enter(_msg := {}) -> void:
	super()
	if _msg.has("animation_name"):
		character.skin.travel(_msg["animation_name"])
