extends CharacterBody3D

@export var speed := 1200
@export var gravity := -9.8

# Appelle la méthode _physics_process chaque frame
func _physics_process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")  # Axe horizontal
	input.z = Input.get_axis("move_forward", "move_back")  # Axe vertical

	# Récupère la caméra
	var camera = get_viewport().get_camera_3d()
	var cam_forward = -camera.transform.basis.z  # Utilise le vecteur avant inversé
	var cam_right = camera.transform.basis.x

	# Calcule la direction de mouvement par rapport à la caméra
	var direction = (cam_right * input.x + cam_forward * -input.z).normalized()  # Inversion de l'axe Z

	# Appliquer le déplacement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Appliquer la gravité
	if not is_on_floor():
		velocity.y += gravity * delta

	# Déplacer le joueur avec glissement sur les surfaces
	move_and_slide()

	# Faire tourner le personnage en fonction de la direction
	if direction.length() > 0:
		# Tourner le personnage vers la direction de mouvement
		look_at(global_transform.origin + direction, Vector3.UP)
