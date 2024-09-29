extends Node3D  


var next_scene_path: String = "res://Scenes/Main.tscn"


func _ready() -> void:
	# Création et configuration d'un Timer pour la durée de la transition
	var transition_timer = Timer.new()
	transition_timer.wait_time = 6.0 
	transition_timer.one_shot = true  # Le timer ne se répète pas
	transition_timer.connect("timeout", Callable(self, "_on_transition_timeout"))
	add_child(transition_timer)
	
	# Démarrer le timer
	transition_timer.start()

# Appelle la scene lorsque timer à zéro
func _on_transition_timeout() -> void:
	# Charger la scène suivante
	get_tree().change_scene_to_file(next_scene_path)
