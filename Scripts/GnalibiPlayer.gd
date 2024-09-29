extends RigidBody3D

@export var inv: Inv
@export var speed := 1200
@export var level: LevelLogic
@export var animplayer : AnimationPlayer

var velocity: Vector3
var direction: Vector3
var on_wall: bool = false  # Variable pour savoir si le joueur est contre un mur
var current_surface_normal: Vector3 = Vector3.UP  # Normale de la surface actuelle (sol ou mur)

@export var ground : Area3D
@export var wall : Area3D

@onready var THROWNOBJECT = preload("res://Scenes/throwed_object.tscn")
var isThrowing = false

func _ready() -> void:
	level = %LevelLogic
	assert(level)  # Vérifie que le niveau est défini
	assert(ground)
	assert(wall)
	ground.body_entered.connect(floor_entered)
	ground.body_exited.connect(floor_exited)
	wall.body_entered.connect(wall_entered)
	wall.body_exited.connect(wall_exited)
	animplayer.get_animation("idle").loop_mode = Animation.LOOP_LINEAR
	animplayer.get_animation("slidin").loop_mode = Animation.LOOP_LINEAR


# Appelé chaque frame (pour l'input)
func _process(_delta: float) -> void:
	var input := Vector3.ZERO
	input.z = Input.get_axis("move_right","move_left")  # Axe horizontal
	input.x = Input.get_axis("move_forward","move_back")  # Axe vertical

	# Récupère la caméra
	var camera = get_viewport().get_camera_3d()
	var cam_forward: Vector3 = -camera.transform.basis.z  # Utilise le vecteur avant inversé
	var cam_right: Vector3 = camera.transform.basis.x

	# Calcule la direction de mouvement par rapport à la caméra
	direction = (cam_right * input.x + cam_forward * -input.z).normalized()  # Inversion de l'axe Z

	# Calcule le déplacement du joueur en fonction de la surface sur laquelle il se trouve
	velocity = calculate_movement(input)
	if velocity.length_squared() < 1.:
		animplayer.play("idle")
	else:
		animplayer.play("slidin")


# Calcule le mouvement du joueur en fonction de la normale de la surface
func calculate_movement(input: Vector3) -> Vector3:
	var move_velocity: Vector3

	# Calculer le mouvement en fonction de la surface (sol ou mur)
	if current_surface_normal == Vector3.UP:
		# Le joueur est sur le sol, mouvement standard
		move_velocity = Vector3(input.x, 0, input.z).normalized() * speed
	else:
		# Le joueur est sur un mur, ajuster le mouvement en fonction du mur
		var wall_tangent: Vector3 = current_surface_normal.cross(Vector3.UP).normalized()
		move_velocity = (wall_tangent * input.x + current_surface_normal.cross(wall_tangent) * input.z).normalized() * speed

	return move_velocity

# Appelle la méthode _physics_process chaque frame
func _physics_process(delta: float) -> void:
	look_at_direction(delta)

	# Déplacer le joueur avec glissement sur les surfaces
	move(delta)

func move(delta: float) -> void:
	# Applique le mouvement basé sur la vélocité
	position += velocity * delta
	velocity = Vector3.ZERO

func look_at_direction(_delta: float) -> void:
	# Faire tourner le personnage en fonction de la direction
	if direction.length() > 0:
		# Tourner le personnage vers la direction de mouvement
		# Aligner le joueur selon la normale de la surface (pour se "coller" au mur)
		look_at(global_transform.origin - direction, current_surface_normal)

# Appelée lorsque le joueur entre dans l'Area3D (sol)
func floor_entered(body: Node3D) -> void:
	if body == self:
		on_wall = false  # Le joueur est au sol
		current_surface_normal = Vector3.UP  # Réinitialiser la normale à celle du sol
		print("Entering floor")

# Appelée lorsque le joueur sort de l'Area3D (sol)
func floor_exited(body: Node3D) -> void:
	if body == self:
		print("Leaving floor")
	
# Appelée lorsque le joueur entre dans l'Area3D (mur)
func wall_entered(body: Node3D) -> void:
	if body == self:
		on_wall = true  # Le joueur est sur le mur
		current_surface_normal = body.global_transform.basis.y.normalized()  # Définir la normale du mur
		print("Entering wall")

# Appelée lorsque le joueur sort de l'Area3D (mur)
func wall_exited(body: Node3D) -> void:
	if body == self:
		on_wall = false  # Le joueur quitte le mur
		current_surface_normal = Vector3.UP  # Réinitialiser la normale à celle du sol
		print("Leaving wall")

func _on_lancer_par_la_fenetre_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		for i in self.inv.Items:
			if i.HowToClean == 0:
				
				#Anim Lancer?
				
				_throw(i.object,Vector3(2,3,-20))
				self.inv.Items.remove_at(0)

func _throw(object: PackedScene,tp: Vector3):
	if isThrowing == false:
		isThrowing = true
		var targetPosition = tp

		var thrownObject = THROWNOBJECT.instantiate()
		
		thrownObject.StartingPosition = self.position
		thrownObject.TargetPosition = targetPosition
		thrownObject.thrownItem = object
		
		get_parent().add_child(thrownObject)
		
		thrownObject.position = Vector3()
