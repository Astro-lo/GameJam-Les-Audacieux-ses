extends Control

func _ready():
	var goback_button = $CanvasLayer/MarginContainer3/GoBackButton

	
	goback_button.connect("pressed", Callable(self, "_on_GoBackButton_pressed"))

func _on_GoBackButton_pressed():
	var menu_scene_path = "res://Scenes/menu.tscn"
	get_tree().change_scene_to_file(menu_scene_path)
	
