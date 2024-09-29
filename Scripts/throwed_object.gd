extends Path3D

@export var speed = 10
@export var StartingPosition: Vector3
@export var TargetPosition: Vector3
@export var thrownItem: PackedScene

@onready var path_follow_3d = $PathFollow3D

func _ready():
	var Item_instance = thrownItem.instantiate()
	path_follow_3d.add_child(Item_instance)
	
	curve.set_point_position(0,StartingPosition)
	curve.set_point_out(0,Vector3(0, abs(TargetPosition.y),TargetPosition.z / 2))
	curve.set_point_position(1, TargetPosition)

func _process(delta: float) -> void:
	if path_follow_3d.progress_ratio == 1:
		thrownItem = null
		self.queue_free()
	path_follow_3d.progress += speed*delta
