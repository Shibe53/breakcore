extends CharacterBody2D
class_name Player

@onready var hurtbox = $Hurtbox

@export var ACCELERATION = 800
@export var MAX_SPEED = 200
@export var FRICTION = 500
@export var controls : Resource = null

enum {
	MOVE
}

var stats = PlayerStats
var state = MOVE

func _ready():
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	input_vector.y = Input.get_action_strength(controls.move_down) - Input.get_action_strength(controls.move_up)
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not hurtbox.invincible:
		stats.health -= area.damage
		var knockback_direction = area.owner.position.direction_to(position)
		velocity = knockback_direction * 200
		hurtbox.start_invincibility(0.6)

func _on_hurtbox_invincibility_ended() -> void:
	pass

func _on_hurtbox_invincibility_started() -> void:
	pass
