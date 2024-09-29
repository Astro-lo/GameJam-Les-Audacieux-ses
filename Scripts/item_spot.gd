extends MeshInstance3D

@export var object : String

func _ready() -> void:
	self.visible = false

#Takes an item out of the player's inventory and puts it back in its place if it's the right item
func put_back_item(plr):
	check_plr_inv(plr)
	self.queue_free()

func check_plr_inv(plr):
	if plr.inv.Items[0].objectType == object:
		var Item_instance = plr.inv.Items[0].object.instantiate()
		
		get_tree().root.add_child(Item_instance)
		Item_instance.position = self.position
		
		plr.inv.Items.remove_at(0)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D":
		if self.visible == true:
			put_back_item(body)
