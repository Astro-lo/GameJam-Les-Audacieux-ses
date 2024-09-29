extends Node
class_name SoundMan

var music : AudioStream= load("res://Sound/bgm_theme.ogg")
var laughs : Array

var pickUp : AudioStream = load("res://Sound/sfx_pick_up.ogg")
var putGlass : AudioStream= load("res://Sound/sfx_put_buttle.ogg")
var putHeavy : AudioStream= load("res://Sound/sfx_put_heayv.ogg")
var putMetal : AudioStream= load("res://Sound/sfx_put_metal.ogg")
var putWood : AudioStream= load("res://Sound/sfx_put_wooden.ogg")
var cleanUp : AudioStream= load("res://Sound/sfx_clean.ogg")
var doorOpen : AudioStream= load("res://Sound/sfx_door_open.ogg")

var musicPlayer : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	musicPlayer = AudioStreamPlayer.new()
	
	laughs.push_front(load("res://Sound/sfx_laugh_1.ogg"))
	laughs.push_front(load("res://Sound/sfx_laugh_2.ogg"))
	laughs.push_front(load("res://Sound/sfx_laugh_3.ogg"))
	laughs.push_front(load("res://Sound/sfx_laugh_4.ogg"))
	
func play_random_laugh(parent : Node) -> void:
	var laugh = laughs.pick_random()
	if laugh is AudioStream:
		play(parent, laugh as AudioStream)
		
func play_level_music(parent : Node) -> void:
	parent.add_child(musicPlayer)
	musicPlayer.stream = music;
	musicPlayer.volume_db = -5
	musicPlayer.play()
		
func stop_level_music() -> void:
	musicPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(parent : Node, stream : AudioStream) -> void:
	var audio_stream_player = AudioStreamPlayer2D.new()
	
	parent.add_child(audio_stream_player)
	audio_stream_player.bus = "Effects"
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = 0
	audio_stream_player.pitch_scale = 1
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player.queue_free)
