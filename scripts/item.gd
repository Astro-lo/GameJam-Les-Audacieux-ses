extends MeshInstance3D

#Books, Painting, etc... this is simply to see where the item can be placed specificaly
@export var object: String

var player_inv = preload("res://Scenes/Inventory/inventory.tres")
#When the player walks over the item it will be put into the player's inventory
func pick_up():
	#get the player's inventory and places itself here
	#start a function that highlights where it can be placed
	#destroy itself
	pass

func add_to_inv(item):
	
