extends ColorRect

@export var SPEED = 100 #uupx/s

var move = false
var progress = 0.0

func _process(delta: float) -> void:
	if move:
		position.x += SPEED * delta
		progress += delta
		if(progress >= 2.0):
			move = false
			position.x = -100
			progress = 0

func _input(event):
	if event.as_text() == "U":
		move = true
