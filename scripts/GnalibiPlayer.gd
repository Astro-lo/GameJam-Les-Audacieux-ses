extends RigidBody3D

@export var inv: Inv
@export var speed := 1200
#@export var gravity := -9.8
@export var level: LevelLogic

var velocity: Vector3
var direction: Vector3
var on_wall: bool = false  # Variable pour savoir si le joueur est contre un mur

@export var ground : Area3D
@export var wall : Area3D


func _ready() -> void:
	level = %LevelLogic
	assert(level)  # Vérifie que le niveau est défini
	assert(ground)
	assert(wall)
	ground.body_entered.connect(floor_entered)
	ground.body_exited.connect(floor_exited)
	wall.body_entered.connect(wall_entered)
	wall.body_exited.connect(wall_exited)
	
	
# Appelé chaque frame (pour l'input)
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")  # Axe horizontal
	input.z = Input.get_axis("move_forward", "move_back")  # Axe vertical

	# Récupère la caméra
	var camera = get_viewport().get_camera_3d()
	var cam_forward: Vector3 = -camera.transform.basis.z  # Utilise le vecteur avant inversé
	var cam_right: Vector3 = camera.transform.basis.x

	# Calcule la direction de mouvement par rapport à la caméra
	direction = (cam_right * input.x + cam_forward * -input.z).normalized()  # Inversion de l'axe Z

	# Appliquer le déplacement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Appliquer la gravité uniquement si le joueur n'est pas sur un mur
	if not on_wall:
		gravity_scale = 1
		#velocity.y = gravity * delta  # Applique la gravité
	else: gravity_scale = 0
	
# Appelle la méthode _physics_process chaque frame
func _physics_process(delta: float) -> void:
	look_at_direction(delta)

	# Déplacer le joueur avec glissement sur les surfaces
	move(delta)

func move(delta: float) -> void:
	# Applique le mouvement basé sur la vélocité
	position += velocity * delta
	velocity = Vector3.ZERO

func look_at_direction(delta: float) -> void:
	# Faire tourner le personnage en fonction de la direction
	if direction.length() > 0:
		# Tourner le personnage vers la direction de mouvement
		look_at(global_transform.origin - direction, Vector3.UP)

# Appelée lorsque le joueur entre dans l'Area3D
func floor_entered(body: Node3D) -> void:
	if body == self :
		print("coucou")
		
# Appelée lorsque le joueur sort de l'Area3D
func floor_exited(body: Node3D) -> void:
	pass
	
# Appelée lorsque le joueur entre dans l'Area3D
func wall_entered(body: Node3D) -> void:
	if body == self :
		print("bonjour")

# Appelée lorsque le joueur sort de l'Area3D
func wall_exited(body: Node3D) -> void:
	pass
	
