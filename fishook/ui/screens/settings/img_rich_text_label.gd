extends RichTextLabel
class_name ImgRichTextLabel

## The opening tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var icons_opening_marker: String = "[img]"
## The closing tag marker. What is after this is going to be converted into a BBCODE image tag.
@export var icons_closing_marker: String = "[/img]"
## The icons path template. Where we search for the images.
@export var icons_path_template: String = "res://ui/assets/controller_prompts/%s.png"
## The BBCODE img template. What's going to be added.
@export var icons_bbcode_template: String = "[img=40]%s[/img]"


func add_text_icons(new_text: String) -> void:
	self.text = parse_text(new_text)


func parse_text(_text: String) -> String:
	var tag_pos = _text.find(icons_opening_marker)
	while tag_pos != -1:
		_text = replace_tag_at_pos(_text, tag_pos)
		tag_pos = _text.find(icons_opening_marker, tag_pos + icons_opening_marker.length())

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