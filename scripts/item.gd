extends MeshInstance3D

#Books, Painting, etc... this is simply to see where the item can be placed specificaly
@export var object: String

var player_inv = preload("res://Scenes/Inventory/inventory.tres")

#When the player walks over the item it will be put into the player's inventory
func pick_up(plr):
	print(plr.inv.Item.size())
	#start a function that highlights where it can be placed
	#destroy itself

func add_to_inv(item):
	pass


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	pick_up(body)
