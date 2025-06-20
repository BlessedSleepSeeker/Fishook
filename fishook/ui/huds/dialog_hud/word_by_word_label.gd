extends Label
class_name WordByWordLabel

@export var word_separator: String = " "
@export var word_delay: float = 0.1

@export var play_sound_on_word: bool = true
@export var noises_on_word: Array[AudioStream] = []

@onready var sound_player: RandomStreamPlayer = $RandomStreamPlayer

func _ready():
	self.visible_characters = 0
	sound_player.streams = noises_on_word

func update_dialog(new_text: String, launch_animation: bool = true):
	self.visible_characters = 0
	self.text = new_text
	if launch_animation:
		display_text()

func display_text() -> void:
	while self.visible_characters != -1:
		display_one_more_word()
		if play_sound_on_word:
			sound_player.play_random()
		await get_tree().create_timer(word_delay).timeout

	print("finished")

func display_one_more_word() -> void:
	self.visible_characters = find_next_separator()

func find_next_separator() -> int:
	var next_separator_position: int = text.find(word_separator, self.visible_characters + word_separator.length())
	return (next_separator_position if next_separator_position > 0 else -1)