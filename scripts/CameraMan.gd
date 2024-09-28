extends Node

@export var cameraLeft : Camera3D
@export var cameraRight : Camera3D

@export var triggerLeft : Area3D
@export var triggerRight : Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(triggerLeft)
	assert(triggerRight)
	
	assert(cameraLeft)
	assert(cameraRight)
	
	triggerLeft.body_entered.connect(entered_area_left);
	triggerRight.body_entered.connect(entered_area_right);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func entered_area_left(body: Node3D) ->void:
	cameraRight.make_current();
	pass

func entered_area_right(body: Node3D) ->void:
	cameraLeft.make_current();
	pass
