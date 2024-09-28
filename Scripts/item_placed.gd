extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector3()
	var tween = create_tween()
	tween.tween_property(self, "scale",Vector3(1.1,1.1,1.1),0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale",Vector3(1,1,1),0.1).set_trans(Tween.TRANS_SINE)
