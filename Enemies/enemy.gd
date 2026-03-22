extends CharacterBody2D
class_name Enemy

@onready var nav_agent = $NavigationAgent2D
@onready var stats = $Stats
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
var tick_damage = false

func _physics_process(delta):
	move_speed = move_toward_int(move_speed, 0, FRICTION * delta)
	move_and_slide()
	
	match state:
		CHASE:
			chase_state()
	
	move_and_slide()

func chase_state():
	move_speed = MAX_SPEED
	if player != null:
		look_at(player.position)
		update_target_position(player.global_transform.origin)

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
