extends CharacterBody2D

@onready var hurtbox = $Hurtbox
@onready var push = $Push
@onready var sprite = $AnimatedSprite2D

@export var ACCELERATION = 800
@export var MAX_SPEED = 200
@export var FRICTION = 500
@export var controls : Resource = null
@export_range(1,2) var player_num : int = 1

enum {
	MOVE
}

var stats = PlayerStats
var state = MOVE

func _ready():
	stats.no_health.connect(player_death)
	sprite.animation = "red" if player_num == 1 else "blue"

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
		hurtbox.start_invincibility(2.0)
		push_away()

func push_away():
	var bodies = push.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D:
			var dir = (body.global_position - push.global_position).normalized()
			body.velocity += dir * 3000

func _on_hurtbox_invincibility_ended() -> void:
	pass

func _on_hurtbox_invincibility_started() -> void:
	pass

func player_death():
	self.set_collision_layer_value(2, false)
	queue_free()
