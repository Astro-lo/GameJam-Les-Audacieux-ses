extends Node

@export var music : AudioStream
@export var laughs : Array

@export var pickUp : AudioStream
@export var putGlass : AudioStream
@export var putHeavy : AudioStream
@export var putMetal : AudioStream
@export var putWood : AudioStream
@export var cleanUp : AudioStream
@export var doorOpen : AudioStream

@export var musicPlayer : AudioStreamPlayer
@export var sfxPlayer : AudioStreamPlayer
@export var laughPlayer : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = %LevelLogic
	assert(level)

func play(stream : AudioStream) -> void:
	sfxPlayer.stream = stream
	sfxPlayer.play()

func play_random_laugh() -> void:
	var laugh = laughs.pick_random()
	if laugh is AudioStream:
		laughPlayer.stream = laugh as AudioStream
		laughPlayer.play()
		
func play_level_music() -> void:
	musicPlayer.stream = music;
	musicPlayer.play()
		
func stop_level_music() -> void:
	musicPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
