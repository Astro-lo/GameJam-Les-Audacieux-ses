extends Path3D

@export var speed = 10
@export var TargetPosition: Vector3
@export var thrownItem: PackedScene

@onready var path_follow_3d = $PathFollow3D

func _ready():
	print("newOne")
	var Item_instance = thrownItem.instantiate()
	path_follow_3d.add_child(Item_instance)
	
	#curve.set_point_out(0,Vector3(0, - abs(TargetPosition.z), TargetPosition.z / 2))
	curve.set_point_position(1, TargetPosition)

func _process(delta: float) -> void:
	if path_follow_3d.progress_ratio == 1:
		print("delete")
		thrownItem = null
		self.queue_free()
	path_follow_3d.progress += speed*delta
	print(path_follow_3d.progress_ratio)
