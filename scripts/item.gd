extends MeshInstance3D

#le FileSystem path a l'objet correspondant dans le fichier Item_placed
@export var pathToObject: String
#Sur le tableau excel des objets, comment cet objet est il rangé
@export var howToClean: int
#Painting,Item,Livres etc...
@export var objectType: String

#When the player walks over the item it will be put into the player's inventory
func add_to_inv(plr):
	var theItemInTheInv = InvItem.new()
	theItemInTheInv.name = self.name
	theItemInTheInv.objectType = objectType
	theItemInTheInv.object = load(pathToObject)
	
	plr.inv.Items.append(theItemInTheInv)
	print(plr.inv.Items[0].name)

func pick_up(plr):
	add_to_inv(plr)
	showSpots()
	self.queue_free()

func showSpots():
	for i in get_node("../ItemSpots").get_children():
		print(i.object, objectType)
		if i.object == objectType:
			i.visible = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "CharacterBody3D":
		if howToClean == 0:
			pass
		elif howToClean == 1:
			pass
		elif howToClean == 2:
			pick_up(body)
		elif howToClean == 3:
			pass
