extends Node

@export var cameraLeft : Camera3D
@export var cameraRight : Camera3D

@export var triggerLeft : Area3D
@export var triggerRight : Area3D

@export var fireplace : MeshInstance3D
@export var chimney : MeshInstance3D
@export var ground : MeshInstance3D
@export var frontBox : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(triggerLeft)
	assert(triggerRight)
	
	assert(cameraLeft)
	assert(cameraRight)
	
	triggerLeft.body_entered.connect(entered_area_left);
	triggerRight.body_entered.connect(entered_area_right);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _swapRoom(input: MeshInstance3D, leftSide: bool, screenmode: bool = false) -> void:
	var m = input.get_active_material(0)
	m.set("secondUVSet", leftSide)
	m.set("roomSideLeft", leftSide)
	m.set("screenMode", screenmode)

func entered_area_left(_node: Node3D) ->void:
	cameraRight.make_current()
	_swapRoom(fireplace, true)
	_swapRoom(chimney, true)
	_swapRoom(frontBox, true)
	_swapRoom(ground, true, true)
	
func entered_area_right(_node: Node3D) ->void:
	cameraLeft.make_current();
	_swapRoom(fireplace, false)
	_swapRoom(chimney, false)
	_swapRoom(frontBox, false)
	_swapRoom(ground, false, true)
	
