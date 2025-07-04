extends Node


var language: String = "auto"

func _ready():
	apply_translation()

func apply_translation() -> void:
	if language == "auto":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)

#region Testing
func _unhandled_input(_event):
	if Input.is_action_just_pressed("test_toggle"):
		test_toggle_lang()

var test_toggle: bool = false
func test_toggle_lang():
	test_toggle = !test_toggle
	if test_toggle:
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("fr")

## Find \[tr\]\[/tr\] enclosed text and call `tr()` on it
func translate_rich(text: String, translation_tag_open: String = "[tr]", translation_tag_close: String = "[/tr]") -> String:
	var tag_pos = text.find(translation_tag_open)
	while tag_pos != -1:
		text = replace_tag_at_pos(text, tag_pos, translation_tag_open, translation_tag_close)
		tag_pos = text.find(translation_tag_open, tag_pos + translation_tag_open.length())
	return text

func replace_tag_at_pos(_text: String, tag_start_pos: int, translation_tag_open: String = "[tr]", translation_tag_close: String = "[/tr]") -> String:
	var tag_end_pos: int = _text.find(translation_tag_close, tag_start_pos)
	if tag_end_pos == -1:
		push_error("Opening Tag %s at position %d is never closed." % [translation_tag_open, tag_start_pos])
		return _text
	var tag_start_offset_pos: int = tag_start_pos + translation_tag_open.length()
	var tag_length: int = tag_end_pos - tag_start_offset_pos
	var tag_data: String = _text.substr(tag_start_offset_pos, tag_length)
	
	var translated_txt: String = tr(tag_data)

	var replace_length = translation_tag_open.length() + tag_length + translation_tag_close.length()
	return _text.replace(_text.substr(tag_start_pos, replace_length), translated_txt)