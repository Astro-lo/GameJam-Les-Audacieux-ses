extends Node
class_name LevelLogic

@export var totalTimeSeconds := 177
@export var Animplayer : AnimationPlayer

signal animNow

var gameStarted := false
var gameEnded = false
var timeRemaining : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	begin_game() # todo ecran titre
	

func get_time_seconds() -> float:
	return timeRemaining

func begin_game() -> void:
	timeRemaining = totalTimeSeconds
	gameStarted = true
	
	SoundManGlobal.play_level_music(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameStarted == true:
		if timeRemaining > 0:
			timeRemaining -= delta;
		elif gameEnded == false:
			gameEnded = true
			animNow.emit()
			Animplayer.play("guyOpenDoor")
			await get_tree().create_timer(5.3).timeout
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
			#fait le compte du score
			
	
	
	
	
