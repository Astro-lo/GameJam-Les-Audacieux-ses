extends RigidBody3D

@export var speed := 1200
@export var gravity := -9.8

var velocity:Vector3;
var direction:Vector3;

# Appelé chaque frame (pour l'input) 
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")  # Axe horizontal
	input.z = Input.get_axis("move_forward", "move_back")  # Axe vertical

	# Récupère la caméra
	var camera = get_viewport().get_camera_3d()
	var cam_forward:Vector3 = -camera.transform.basis.z  # Utilise le vecteur avant inversé
	var cam_right:Vector3 = camera.transform.basis.x

	# Calcule la direction de mouvement par rapport à la caméra
	direction = (cam_right * input.x + cam_forward * -input.z).normalized()  # Inversion de l'axe Z

	# Appliquer le déplacement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Appliquer la gravité - (commenté parce que je sais pas si on va avoir de la gravité en gameplay)
	#if not is_on_floor():
		#velocity.y += gravity * delta
	

# Appelle la méthode _physics_process chaque frame
func _physics_process(delta: float) -> void:
	look_at_direction(delta)

	# Déplacer le joueur avec glissement sur les surfaces
	move(delta)

func move(delta: float) -> void:
	position += velocity * delta;
	
func look_at_direction(delta: float) ->void:
	# Faire tourner le personnage en fonction de la direction
	if direction.length() > 0:
		# Tourner le personnage vers la direction de mouvement
		look_at(global_transform.origin - direction, Vector3.UP)
