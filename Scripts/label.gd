extends Label

@export var level: LevelLogic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(level) # check its here
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var timeRemaining = level.get_time_seconds()
	
	# https://forum.godotengine.org/t/formatting-a-timer/6482
	var minutes = timeRemaining / 60
	var seconds = fmod(timeRemaining, 60)
	var time_string = "%2d:%02d" % [minutes, seconds]
	
	text = time_string
	
