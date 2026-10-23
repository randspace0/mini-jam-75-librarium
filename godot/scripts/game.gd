extends Node
# Autoload: level order, scene switching, shared audio.

const LEVELS := ["res://scenes/level_1.tscn", "res://scenes/level_2.tscn"]
const MENU := "res://scenes/main_menu.tscn"
const MUSIC := {
	"menu": preload("res://assets/audio/1.NYazmin_MainMenu_LOOP.wav"),
	1: preload("res://assets/audio/2.NYazmin_Level1_LOOP.wav"),
	2: preload("res://assets/audio/3.NYazmin_Level2_LOOP.wav"),
}

var level := 1
var _music := AudioStreamPlayer.new()
var _sfx := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(_music)
	add_child(_sfx)

func play_music(key) -> void:
	var stream: AudioStreamWAV = MUSIC[key]
	if _music.stream == stream and _music.playing:
		return
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = stream.data.size() / (2 if stream.format == AudioStreamWAV.FORMAT_16_BITS else 1) / (2 if stream.stereo else 1)
	_music.stream = stream
	_music.play()

func play_sfx(stream: AudioStream) -> void:
	_sfx.stream = stream
	_sfx.play()

func start_level(n: int) -> void:
	get_tree().paused = false
	level = n
	play_music(n)
	get_tree().change_scene_to_file(LEVELS[n - 1])

func retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func next_level() -> void:
	if level < LEVELS.size():
		start_level(level + 1)
	else:
		to_menu()

func to_menu() -> void:
	get_tree().paused = false
	play_music("menu")
	get_tree().change_scene_to_file(MENU)
