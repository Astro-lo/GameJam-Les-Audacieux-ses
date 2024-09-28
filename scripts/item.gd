extends MeshInstance3D

#Books, Painting, etc... this is simply to see where the item can be placed specificaly
@export var pathToObject: String

#When the player walks over the item it will be put into the player's inventory

func add_to_inv(plr):
	var theItemInTheInv = InvItem.new()
	theItemInTheInv.name = self.name
	theItemInTheInv.object = load(pathToObject)
	
	plr.inv.Items.append(theItemInTheInv)
	print(plr.inv.Items[0].name)

func pick_up(plr):
	add_to_inv(plr)
	#start a function that highlights where it can be placed
	self.queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "CharacterBody3D":
		pick_up(body)
