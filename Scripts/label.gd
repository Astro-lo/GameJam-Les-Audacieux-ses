extends Label

@export var level: LevelLogic

var time_since_last_update: float = 0.0  # Temps écoulé depuis la dernière mise à jour
var is_enlarged: bool = false
var scale_factor_normal: float = 1.0  # scale normal
var scale_factor_enlarged: float = 1.1  # scale agrandi

# Appelé lorsque le node entre dans la scène
func _ready() -> void:
	assert(level) # Vérifie que l'objet level existe bien
	
	scale = Vector2(scale_factor_normal, scale_factor_normal)  # Taille normale du texte

# Appelé à chaque frame
func _process(delta: float) -> void:
	var time_remaining = level.get_time_seconds()
	
	# Formater le temps 
	var minutes = time_remaining / 60
	var seconds = fmod(time_remaining, 60)
	var time_string = "%2d:%02d" % [minutes, seconds]
	text = time_string
	
	# Effet de battement chaque demiseconde
	time_since_last_update += delta
	if time_since_last_update >= 0.5:
		time_since_last_update = 0.0  # Réinitialiser le temps écoulé
		
		# Alterner entre agrandi et taille normale
		if is_enlarged:
			# Revenir à la taille normale
			scale = Vector2(scale_factor_normal, scale_factor_normal)
		else:
			# Agrandir légèrement le texte
			scale = Vector2(scale_factor_enlarged, scale_factor_enlarged)
		
		# Inverser booléen
		is_enlarged = not is_enlarged
