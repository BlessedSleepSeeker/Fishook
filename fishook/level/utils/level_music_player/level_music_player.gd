extends Node
class_name LevelMusicPlayer

@export var random_play_on_load: bool = true

@export var musics: Array[AudioStream] = []
@export_range(0.1, 10, 0.1) var crossfade_duration: float = 1.0
@export var crossfade_out_volume: float = -40.0
@export var crossfade_in_volume: float = 0.0
@export var loop_music: bool = true

@onready var audio_player1: AudioStreamPlayer = %AudioStreamPlayer1
@onready var audio_player2: AudioStreamPlayer = %AudioStreamPlayer2

@onready var current_player: AudioStreamPlayer = %AudioStreamPlayer1
@onready var unused_player: AudioStreamPlayer = %AudioStreamPlayer2

var audio_stream_id: int = 0:
	set(value):
		if value < 0:
			audio_stream_id = musics.size() - 1
		elif value >= musics.size():
			audio_stream_id = 0
		else:
			audio_stream_id = value
		play_by_id(audio_stream_id)

var input_disabled: bool = false

func _ready():
	if random_play_on_load:
		random_play()

func _unhandled_input(_event):
	if input_disabled:
		return
	if Input.is_action_just_pressed("music_next"):
		audio_stream_id += 1
	if Input.is_action_just_pressed("music_prev"):
		audio_stream_id -= 1

func random_play() -> void:
	var music: AudioStream = musics.pick_random()
	audio_stream_id = musics.find(music)

func play_by_id(id: int):
	if id > musics.size() - 1 || id < 0:
		push_error("ID is Out of bounds")
	play(musics[id])

func play(audio_stream: AudioStream) -> void:
	unused_player.stream = audio_stream
	if current_player.playing:
		unused_player.play(calculate_song_position(audio_stream, current_player))
	else:
		unused_player.play()
	var fade_current_tween = get_tree().create_tween()
	var fade_unused_tween = get_tree().create_tween()

	fade_current_tween.tween_property(current_player, "volume_db", crossfade_out_volume, crossfade_duration)
	fade_unused_tween.tween_property(unused_player, "volume_db", crossfade_in_volume, crossfade_duration)


	var switch = current_player
	current_player = unused_player
	unused_player = switch
	if not current_player.finished.is_connected(_on_song_end):
		current_player.finished.connect(_on_song_end)
	if unused_player.finished.is_connected(_on_song_end):
		unused_player.finished.disconnect(_on_song_end)
	fade_current_tween.finished.connect(stop_unused)

func stop_unused() -> void:
	unused_player.stop()

func calculate_song_position(future_stream: AudioStream, _current_player: AudioStreamPlayer) -> float:
	var current_percent: float = _current_player.get_playback_position() / _current_player.stream.get_length()

	var future_position: float = future_stream.get_length() * current_percent
	return future_position

func _on_song_end():
	audio_stream_id += 1

func change_volume(volume_mod: float, duration: float) -> void:
	var fade_current_tween = get_tree().create_tween()
	var fade_unused_tween = get_tree().create_tween()

	fade_current_tween.tween_property(current_player, "volume_db", crossfade_in_volume + volume_mod , duration)
	fade_unused_tween.tween_property(unused_player, "volume_db", crossfade_out_volume + volume_mod, duration)