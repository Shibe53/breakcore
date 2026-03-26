extends CharacterBody2D
class_name Enemy

@onready var nav_agent = $NavigationAgent2D
@onready var stats = $Stats

const ACCELERATION = 260
const MAX_SPEED = 40
const FRICTION = 100

@export var ENEMY_TYPE : String = "Small"

enum {
	CHASE,
	RECOMPUTE
}

var player = null
var state = CHASE
var move_speed = MAX_SPEED
var tick_damage = false
var knockback_velocity = Vector2.ZERO
var knockback_time = 0.0

func _ready():
	for child in get_parent().get_children():
		if child.is_in_group("player"):
			player = child
			break

func _physics_process(delta):
	if knockback_time > 0:
		knockback_time -= delta
		
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 4000 * delta)
		
		move_and_slide()
		return
		
	move_speed = move_toward_int(move_speed, 0, FRICTION * delta)
	
	match state:
		CHASE:
			chase_state()
		RECOMPUTE:
			recompute_player()
	
	move_and_slide()

func chase_state():
	move_speed = MAX_SPEED
	if player != null:
		look_at(player.position)
		update_target_position(player.global_transform.origin)

func recompute_player():
	for child in get_parent().get_children():
		if child.is_in_group("player"):
			player = child
			break
	state = CHASE

func _on_stats_no_health() -> void:
	queue_free()

func update_target_position(target_pos : Vector2):
	var current_pos : Vector2 = self.global_transform.origin
	var next_pos : Vector2 = nav_agent.get_next_path_position()
	var new_velocity : Vector2 = current_pos.direction_to(next_pos)
	nav_agent.velocity = new_velocity
	nav_agent.target_position = target_pos

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if safe_velocity.length() > 0.001:
		var target_dir = safe_velocity.normalized()
		var current_dir = velocity.normalized() if velocity.length() > 0.001 else target_dir
				# Smoothly turn toward the new direction
		var smooth_dir = current_dir.lerp(target_dir, 0.075).normalized()
		velocity = smooth_dir * move_speed
	move_and_slide()

func move_toward_int(current: int, target: int, step: int) -> int:
	if current < target:
		return min(current + step, target)
	elif current > target:
		return max(current - step, target)
	return current

func deal_tick_damage(damage):
	if tick_damage:
		stats.health -= damage
		await get_tree().create_timer(0.2).timeout
		deal_tick_damage(damage)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	tick_damage = true
	deal_tick_damage(area.damage)

func _on_hurtbox_area_exited(area: Area2D) -> void:
	tick_damage = false
