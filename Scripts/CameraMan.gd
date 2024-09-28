extends Node

@export var cameraLeft : Camera3D
@export var cameraRight : Camera3D

@export var triggerLeft : Area3D
@export var triggerRight : Area3D

@export var fireplace : Mesh
@export var chimney : Mesh
@export var ground : Mesh
@export var frontBox : Mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	triggerLeft.area_entered.connect(entered_area_left);
	triggerRight.area_entered.connect(entered_area_right);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _swapRoom(input: Mesh, leftSide: bool, screenmode: bool = false) -> void:
	var m = input.surface_get_material(0)
	m.set("secondUVSet", leftSide)
	m.set("roomSideLeft", leftSide)
	m.set("screenMode", screenmode)

func entered_area_left() ->void:
	cameraLeft.make_current()
	_swapRoom(fireplace, true)
	_swapRoom(chimney, true)
	_swapRoom(frontBox, true)
	_swapRoom(ground, true, true)
	pass

func entered_area_right() ->void:
	cameraRight.make_current();
	_swapRoom(fireplace, false)
	_swapRoom(chimney, false)
	_swapRoom(frontBox, false)
	_swapRoom(ground, false, true)
	pass
