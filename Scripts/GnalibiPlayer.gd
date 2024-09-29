extends RigidBody3D

@export var inv: Inv
@export var speed := 1200
@export var level: LevelLogic
@export var animplayer : AnimationPlayer

var velocity: Vector3
var direction: Vector3
var on_wall: bool = false  # Variable pour savoir si le joueur est contre un mur
var current_movement_area: Area3D

@export var ground : Area3D
@export var walls : Array[Area3D]

@onready var THROWNOBJECT = preload("res://Scenes/throwed_object.tscn")
var isThrowing = false

func _ready() -> void:
	level = %LevelLogic
	assert(level)  # Vérifie que le niveau est défini
	assert(ground)
	ground.body_entered.connect(floor_entered)
	ground.body_exited.connect(floor_exited)
	
	for wall in walls:
		assert(wall)
		var callback = func(body: Node3D):
			wall_entered(wall, body)
			
		wall.body_entered.connect(callback)
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
	var cam_forward: Vector3 = camera.transform.basis.z  # Utilise le vecteur avant inversé
	var cam_right: Vector3 = camera.transform.basis.x
	var cam_up: Vector3 = camera.transform.basis.y

	# Calcule la direction de mouvement par rapport à la caméra
	if on_wall:
		print(input)
		direction = (cam_right * input.x - cam_up * input.z).normalized()
	else:
		direction = (-cam_right * input.z + cam_forward * input.x).normalized() 
		
	# Calcule le déplacement du joueur en fonction de la surface sur laquelle il se trouve
	velocity = calculate_movement(direction)
	if velocity.length_squared() < 1.:
		animplayer.play("idle")
	else:
		animplayer.play("slidin")


# Calcule le mouvement du joueur en fonction de la normale de la surface
func calculate_movement(input: Vector3) -> Vector3:
	
	return input * speed
	#
	#var move_velocity: Vector3
#
	## Calculer le mouvement en fonction de la surface (sol ou mur)
	#if current_movement_area == ground:
		## Le joueur est sur le sol, mouvement standard
		#move_velocity = Vector3(input.x, 0, input.z).normalized() * speed
	#else:
		#if current_movement_area:
			## Le joueur est sur un mur, ajuster le mouvement en fonction du mur
			#var current_surface_normal = get_current_surface_normal()
			#var wall_tangent: Vector3 = current_surface_normal.cross(Vector3.UP).normalized()
			#move_velocity = (wall_tangent * input.x + current_surface_normal.cross(wall_tangent) * input.z).normalized() * speed
		#else:
			#pass
#
	#return move_velocity

# Appelle la méthode _physics_process chaque frame
func _physics_process(delta: float) -> void:
	look_at_direction(delta)

	# Déplacer le joueur avec glissement sur les surfaces
	move(delta)

func get_current_area_transform() -> Transform3D:
	return (current_movement_area.get_child(0) as CollisionShape3D).global_transform

func get_current_surface_normal() -> Vector3:
		return get_current_area_transform().basis.y

func move(delta: float) -> void:
	# Applique le mouvement basé sur la vélocité
	var target_position = global_position + velocity * delta
	
	if current_movement_area:
		var area_transform = get_current_area_transform()
		var matrix = area_transform.affine_inverse()
		var position_on_plane = matrix * target_position
		position_on_plane.y = 0
		
		target_position = area_transform * position_on_plane;
	
	global_position = target_position;
	velocity = Vector3.ZERO

func look_at_direction(_delta: float) -> void:
	# Faire tourner le personnage en fonction de la direction
	if direction.length() > 0:
		# Tourner le personnage vers la direction de mouvement
		# Aligner le joueur selon la normale de la surface (pour se "coller" au mur)
		look_at(global_transform.origin - direction, get_current_surface_normal())

# Appelée lorsque le joueur entre dans l'Area3D (sol)
func floor_entered(body: Node3D) -> void:
	if body == self:
		current_movement_area = ground
		on_wall = false  # Le joueur est au sol
		print("Entering floor")

# Appelée lorsque le joueur sort de l'Area3D (sol)
func floor_exited(body: Node3D) -> void:
	if body == self:
		print("Leaving floor")
	
# Appelée lorsque le joueur entre dans l'Area3D (mur)
func wall_entered(wall: Node3D, body: Node3D) -> void:
	if body == self:
		current_movement_area = wall
		on_wall = true  # Le joueur est sur le mur
		print("Entering wall")

# Appelée lorsque le joueur sort de l'Area3D (mur)
func wall_exited(body: Node3D) -> void:
	if body == self:
		print("Leaving wall")

func _on_lancer_par_la_fenetre_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		for i in self.inv.Items:
			if i.HowToClean == 0:
				
				#Anim Lancer?
				
				_throw(i.object,Vector3(2,3,-10))
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
