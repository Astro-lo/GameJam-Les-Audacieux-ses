extends Control

func _ready():
	var play_button = $CanvasLayer/MarginContainer/PlayButton
	var credits_button = $CanvasLayer/MarginContainer3/CreditsButton
	
	play_button.connect("pressed", Callable(self, "_on_PlayButton_pressed"))
	credits_button.connect("pressed", Callable(self, "_on_CreditsButton_pressed"))

func _on_PlayButton_pressed():
	var game_scene_path = "res://Scenes/Main.tscn"
	get_tree().change_scene_to_file(game_scene_path)
	
func _on_CreditsButton_pressed():
	var credits_scene_path = "res://Scenes/credits.tscn"
	get_tree().change_scene_to_file(credits_scene_path)
