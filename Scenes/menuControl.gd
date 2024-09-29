extends Control

func _ready():
	var play_button = $CanvasLayer/MarginContainer/PlayButton
	play_button.connect("pressed", Callable(self, "_on_PlayButton_pressed"))

func _on_PlayButton_pressed():

	var game_scene_path = "res://Scenes/Main.tscn"
	
	# Transition to the game scene
	get_tree().change_scene_to_file(game_scene_path)
