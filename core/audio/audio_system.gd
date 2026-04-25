extends Node
# TODO Priority queue. Even if sound queue is full,
# remove sound with lowest priority to be able to play sound with higher one.
# TODO Positional sounds for 2D with pooling.
# TODO Positional sounds for 3D with pooling.

enum AudioBus {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2,
	UI = 3,
}

#var music_stream_player: Array[AudioStreamPlayer] = []
var _sound_playback: AudioStreamPlaybackPolyphonic
var _ui_playback: AudioStreamPlaybackPolyphonic
var _music_playback: AudioStreamPlaybackInteractive

@onready var _sfx_stream_player: AudioStreamPlayer = %SFXStreamPlayer
@onready var _ui_stream_player: AudioStreamPlayer = %UIStreamPlayer
@onready var _music_stream_player: AudioStreamPlayer = %MusicStreamPlayer


func _ready() -> void:
	_music_stream_player.play()
	_music_playback = _music_stream_player.get_stream_playback()
	_music_stream_player.stop()

	_sfx_stream_player.play()
	_sound_playback = _sfx_stream_player.get_stream_playback()

	_ui_stream_player.play()
	_ui_playback = _ui_stream_player.get_stream_playback()


func play_sfx(audio_stream: AudioStream) -> void:
	_sound_playback.play_stream(audio_stream)

func play_ui(audio_stream: AudioStream) -> void:
	_ui_playback.play_stream(audio_stream)

func play_music(music_name: String) -> void:
	if not _music_stream_player.playing:
		_music_stream_player.play()

	_music_playback.switch_to_clip_by_name(music_name)
