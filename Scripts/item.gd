extends MeshInstance3D

#le FileSystem path a l'objet correspondant dans le fichier Item_placed
@export var pathToObject: String
#Sur le tableau excel des objets, comment cet objet est il rangé
@export var howToClean: int
#Painting,Item,Livres etc...
@export var ObjectType: String

@export var animationPlayer : AnimationPlayer
var AnimState = 0


func _ready() -> void:
	var soundMan = SoundManGlobal
	assert(soundMan)

func _process(_delta: float) -> void:
	if howToClean == 4:
		if AnimState == 0:
			if animationPlayer.has_animation("Before"):
				animationPlayer.play("Before")
		elif AnimState == 1:
			if animationPlayer.has_animation("Closed"):
				animationPlayer.play("Closed")

func clean():
	Score.Objets_nettoyés_score += 10
	Score.Objets_nettoyés_combiens += 1
	SoundManGlobal.play(self, SoundManGlobal.cleanUp)
	var Sx = self.scale.x
	var Sy = self.scale.y
	var Sz = self.scale.z
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale",Vector3(Sx*1.1, Sy*1.1, Sz*1.1),0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale",Vector3(Sx*0.5, Sy*0.5, Sz*0.5),0.1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.25).timeout
	
	self.queue_free()

func pick_up(plr):
	add_to_inv(plr)
	showSpots()
	var tween = create_tween()
	
	var Sx = self.scale.x
	var Sy = self.scale.y
	var Sz = self.scale.z
	
	tween.tween_property(self, "scale",Vector3(Sx*1.1, Sy*1.1, Sz*1.1),0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale",Vector3(Sx*0.5, Sy*0.5, Sz*0.5),0.1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.25).timeout
	self.queue_free()

func pick_up_ranger(plr):
	Score.Objets_rangés_score += 10
	Score.Objets_rangés_combiens += 1
	pick_up(plr)
func pick_up_lancer(plr):
	Score.Objets_lancés_score += 15
	Score.Objets_lancés_combiens += 1
	pick_up(plr)

func put_away():
	if $Area3D.visible == true:
		Score.Objets_bonus_score += 25
		Score.Objets_bonus_combiens += 1
		animItem()
		$Area3D.visible = false
	
func animItem():
	print("anim item")
	AnimState = 2
	animationPlayer.active = true
	if animationPlayer.has_animation("Move"):
		animationPlayer.play("Move")
		
	if animationPlayer.has_animation("BloodyHandAnim"):
		animationPlayer.play("BloodyHandAnim")
		
	if not animationPlayer.is_playing():
		AnimState = 1

func add_to_inv(plr):
	var theItemInTheInv = InvItem.new()
	theItemInTheInv.name = self.name
	theItemInTheInv.HowToClean = howToClean
	theItemInTheInv.objectType = ObjectType
	theItemInTheInv.object = load(pathToObject)
	
	plr.inv.Items.append(theItemInTheInv)
func showSpots():
	if get_parent().get_node("../ItemSpots").get_children() != null:
		for i in get_parent().get_node("../ItemSpots").get_children():
			if i.object == ObjectType:
				var Sx = self.scale.x
				var Sy = self.scale.y
				var Sz = self.scale.z
				
				i.scale = Vector3()
				i.visible = true
				var tween = create_tween()
				tween.tween_property(i, "scale",Vector3(Sx*1.1,Sy*1.1,Sz*1.1),0.3).set_trans(Tween.TRANS_SINE)
				tween.tween_property(i, "scale",Vector3(Sx,Sy,Sz),0.1).set_trans(Tween.TRANS_SINE)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		
		if howToClean == 0:
			if body.inv.Items.size() <1:
				pick_up_lancer(body)
				SoundManGlobal.play(self, SoundManGlobal.pickUp)
		elif howToClean == 1:
			SoundManGlobal.play_random_laugh(self)
			clean()
		elif howToClean == 2:
			if body.inv.Items.size() <1:
				SoundManGlobal.play(self, SoundManGlobal.pickUp)
				pick_up(body)
		elif howToClean == 3:
			pass
		elif howToClean == 4:
			put_away()
