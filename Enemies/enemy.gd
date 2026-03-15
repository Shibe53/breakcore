extends CharacterBody2D
class_name Enemy

@onready var softCollision = $SoftCollision
@onready var player = get_tree().get_first_node_in_group("player")

const ACCELERATION = 260
const MAX_SPEED = 30
const FRICTION = 100

@export var ENEMY_TYPE : String = "Small"

enum {
	CHASE
}

var state = CHASE
var move_speed = MAX_SPEED

func _physics_process(delta):
	move_speed = move_toward_int(move_speed, 0, FRICTION * delta)
	move_and_slide()
	
	match state:
		CHASE:
			chase_state()

	if softCollision.has_overlapping_areas():
		velocity += softCollision.get_push_vector() * delta * 500
	
	move_and_slide()
	
func chase_state():
	move_speed = MAX_SPEED

func move_toward_int(current: int, target: int, step: int) -> int:
	if current < target:
		return min(current + step, target)
	elif current > target:
		return max(current - step, target)
	return current
