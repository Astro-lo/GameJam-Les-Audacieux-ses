extends MeshInstance3D

#le FileSystem path a l'objet correspondant dans le fichier Item_placed
@export var pathToObject: String
#Sur le tableau excel des objets, comment cet objet est il rangé
@export var howToClean: int
#Painting,Item,Livres etc...
@export var ObjectType: String

@export var animationPlayer : AnimationPlayer
var AnimState = 0

var Sx = self.scale.x
var Sy = self.scale.y
var Sz = self.scale.z

func _process(_delta: float) -> void:
	if howToClean == 4:
		if AnimState == 0:
			animationPlayer.play("Before")
		elif AnimState == 1:
			animationPlayer.play("Closed")

func clean():
	#rajouter score
	self.queue_free()

func pick_up(plr):
	add_to_inv(plr)
	showSpots()
	#rajouter score
	var tween = create_tween()
	tween.tween_property(self, "scale",Vector3(Sx*1.1, Sy*1.1, Sz*1.1),0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale",Vector3(Sx*0.5, Sy*0.5, Sz*0.5),0.1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.25).timeout
	self.queue_free()

func put_away():
	if $Area3D.visible == true:
		#rajouter score
		animItem()
		$Area3D.visible = false
	
func animItem():
	AnimState = 2
	animationPlayer.play("Move")
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
	for i in get_parent().get_node("../ItemSpots").get_children():
		if i.object == ObjectType:
			i.scale = Vector3()
			i.visible = true
			var tween = create_tween()
			tween.tween_property(i, "scale",Vector3(Sx*1.1,Sy*1.1,Sz*1.1),0.3).set_trans(Tween.TRANS_SINE)
			tween.tween_property(i, "scale",Vector3(Sx,Sy,Sz),0.1).set_trans(Tween.TRANS_SINE)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		
		if howToClean == 0:
			if body.inv.Items.size() <1:
				pick_up(body)
		elif howToClean == 1:
			clean()
		elif howToClean == 2:
			if body.inv.Items.size() <1:
				pick_up(body)
		elif howToClean == 3:
			pass
		elif howToClean == 4:
			put_away()
