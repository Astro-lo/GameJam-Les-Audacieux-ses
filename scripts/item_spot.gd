extends MeshInstance3D

var player_inv = preload("res://Scenes/Inventory/inventory.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#Takes an item out of the player's inventory and puts it back in its place if it's the right item
func put_back_item():
	#checks the player's inventory
	#if on the of the can be put here then it places the item in its place
	#takes the item out of the player's inventory
	#destroys itself
	pass

func check_plr_inv():
	for i in range(player_inv.item.size()):
		pass