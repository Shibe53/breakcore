extends ColorRect
@export var SPEED = 100; 
#uupx/s
var move = false;
var progress = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		position.x += SPEED * delta
		progress += delta;
		if(progress>=2.0):
			move = false
			position.x = -100;
			progress = 0
	pass

func _input(event):
	if event.as_text() == "U":
		move = true
	pass
