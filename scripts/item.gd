extends MeshInstance3D

#le FileSystem path a l'objet correspondant dans le fichier Item_placed
@export var pathToObject: String
#Sur le tableau excel des objets, comment cet objet est il rangé
@export var howToClean: int
#Painting,Item,Livres etc...
@export var objectType: String

#When the player walks over the item it will be put into the player's inventory

func destroyed():
	#c'est pour les tween et touuut
	self.queue_free()
func clean():
	#rajouter score
	destroyed()
func pick_up(plr):
	add_to_inv(plr)
	showSpots()
	#rajouter score
	var tween = create_tween()
	tween.tween_property(self, "scale",Vector3(1.1,1.1,1.1),0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale",Vector3(0.5,0.5,0.5),0.1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.25).timeout
	self.queue_free()

func add_to_inv(plr):
	var theItemInTheInv = InvItem.new()
	theItemInTheInv.name = self.name
	theItemInTheInv.HowToClean = howToClean
	theItemInTheInv.objectType = objectType
	theItemInTheInv.object = load(pathToObject)
	
	plr.inv.Items.append(theItemInTheInv)
func showSpots():
	for i in get_node("../ItemSpots").get_children():
		if i.object == objectType:
			i.scale = Vector3()
			i.visible = true
			var tween = create_tween()
			tween.tween_property(i, "scale",Vector3(1.1,1.1,1.1),0.3).set_trans(Tween.TRANS_SINE)
			tween.tween_property(i, "scale",Vector3(1,1,1),0.1).set_trans(Tween.TRANS_SINE)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		print("player entered")
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
