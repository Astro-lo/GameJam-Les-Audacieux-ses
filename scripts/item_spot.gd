extends MeshInstance3D

@export var object : String

func _ready() -> void:
	self.visible = false
	
#Takes an item out of the player's inventory and puts it back in its place if it's the right item
func put_back_item(plr):
	check_plr_inv(plr)
	self.queue_free()

func check_plr_inv(plr):
	for i in plr.inv.Items.size():
		if plr.inv.Items[i].objectType == object:
			var Item_instance = plr.inv.Items[i].object.instantiate()
			
			get_tree().root.add_child(Item_instance)
			Item_instance.position = self.position
			Item_instance.rotation = self.rotation
			plr.inv.Items.remove_at(i)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "CharacterBody3D":
		if self.visible == true:
			put_back_item(body)
