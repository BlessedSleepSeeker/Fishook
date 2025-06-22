extends RichTextLabel
class_name WordByWordLabel
## Extended RichTextLabel that transform markers into image from a predefined path template, and display text word by word or letter by letter.
##
## Extended RichTextLabel that transform markers into image from a predefined path template, and display text word by word or letter by letter. Convert what is after [member icons_opening_marker] and before [member icons_closing_marker] to "[member icons_bbcode_template]" % [member icons_path_template] % `tag_data`

@export var word_separator: String = " "
@export var word_delay: float = 0.07
@export var play_sound_on_progress: bool = true
@export var noises_on_progress: Array[AudioStream] = []

@export var letter_delay: float = 0.01
@export var disable_all_animations: bool = false

## The opening tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var icons_opening_marker: String = "[img]"
## The closing tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var icons_closing_marker: String = "[/img]"
## The icons path template. Where we search for the images.
@export var icons_path_template: String = "res://ui/assets/controller_prompts/%s.png"
## The BBCODE img template. What's going to be added.
@export var icons_bbcode_template: String = "[img=50]%s[/img]"

@onready var sound_player: RandomStreamPlayer = $RandomStreamPlayer

signal all_text_displayed

## Transforming real text to allow [img][/img] to count only has one character.
var transformed_text: String = ""

var original_text: String = ""

func _ready():
	self.visible_characters = 0
	sound_player.streams = noises_on_progress

func update_dialog(new_text: String, launch_animation: bool = true, use_letter_by_letter: bool = false):
	original_text = new_text
	var parsed_text = parse_text(new_text)
	if disable_all_animations:
		self.visible_characters = -1
	else:
		self.visible_characters = 0
	self.text = parsed_text
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
	var next_separator_position: int = transformed_text.find(word_separator, self.visible_characters + word_separator.length())
	return (next_separator_position if next_separator_position > 0 else -1)


func parse_text(_text: String) -> String:
	transformed_text = _text
	var tag_pos = _text.find(icons_opening_marker)
	while tag_pos != -1:
		_text = replace_tag_at_pos(_text, tag_pos)
		tag_pos = _text.find(icons_opening_marker, tag_pos + icons_opening_marker.length())
	
	var transformed_tag_pos = transformed_text.find(icons_opening_marker)
	while transformed_tag_pos != -1:
		transformed_text = replace_transformed_tag_at_pos(transformed_text, transformed_tag_pos)
		transformed_tag_pos = transformed_text.find(icons_opening_marker, transformed_tag_pos + icons_opening_marker.length())

	return _text

func replace_tag_at_pos(_text: String, tag_start_pos: int) -> String:
	var tag_end_pos: int = _text.find(icons_closing_marker, tag_start_pos)
	if tag_end_pos == -1:
		push_error("Opening Tag %s at position %d is never closed." % [icons_opening_marker, tag_start_pos])
		return _text
	var tag_start_offset_pos: int = tag_start_pos + icons_opening_marker.length()
	var tag_length: int = tag_end_pos - tag_start_offset_pos
	var tag_data: String = _text.substr(tag_start_offset_pos, tag_length)
	
	var bbcode_txt: String = icons_bbcode_template % icons_path_template % tag_data

	var replace_length = icons_opening_marker.length() + tag_length + icons_closing_marker.length()
	return _text.replace(_text.substr(tag_start_pos, replace_length), bbcode_txt)

func replace_transformed_tag_at_pos(_text: String, tag_start_pos: int) -> String:
	var tag_end_pos: int = _text.find(icons_closing_marker, tag_start_pos)
	if tag_end_pos == -1:
		push_error("Opening Tag %s at position %d is never closed." % [icons_opening_marker, tag_start_pos])
		return _text
	var tag_start_offset_pos: int = tag_start_pos + icons_opening_marker.length()
	var tag_length: int = tag_end_pos - tag_start_offset_pos

	var replace_length = icons_opening_marker.length() + tag_length + icons_closing_marker.length()
	return _text.replace(_text.substr(tag_start_pos, replace_length), "_")