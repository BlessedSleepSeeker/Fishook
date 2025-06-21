extends Label
class_name WordByWordLabel

@export var word_separator: String = " "
@export var word_delay: float = 0.03
@export var play_sound_on_progress: bool = true
@export var noises_on_progress: Array[AudioStream] = []

@export var letter_delay: float = 0.01


@onready var sound_player: RandomStreamPlayer = $RandomStreamPlayer

signal all_text_displayed

func _ready():
	self.visible_characters = 0
	sound_player.streams = noises_on_progress

func update_dialog(new_text: String, launch_animation: bool = true, use_letter_by_letter: bool = false):
	self.visible_characters = 0
	self.text = new_text
	if launch_animation:
		display_text(use_letter_by_letter)

func display_text(use_letter_by_letter: bool = false) -> void:
	while self.visible_characters != -1:
		if use_letter_by_letter:
			self.visible_characters += 1
			if play_sound_on_progress:
				sound_player.play_random()
			await get_tree().create_timer(letter_delay).timeout
		else:
			display_one_more_word()
			if play_sound_on_progress:
				sound_player.play_random()
			await get_tree().create_timer(word_delay).timeout

	all_text_displayed.emit()

func display_one_more_word() -> void:
	self.visible_characters = find_next_separator()

func find_next_separator() -> int:
	var next_separator_position: int = text.find(word_separator, self.visible_characters + word_separator.length())
	return (next_separator_position if next_separator_position > 0 else -1)