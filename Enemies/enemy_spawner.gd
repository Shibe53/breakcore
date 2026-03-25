extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

@export var min_spawn = 250.0
@export var max_spawn = 450.0

func _on_timer_timeout() -> void:
	if player != null:
		spawn_enemy()

func get_random_point(player_pos: Vector2) -> Vector2:
	var angle = randf() * TAU
	var distance = randf_range(min_spawn, max_spawn)
	return player_pos + Vector2(cos(angle), sin(angle)) * distance

func get_valid_spawn(player_pos: Vector2) -> Vector2:
	var nav_map = get_world_2d().navigation_map
	
	for i in range(20):
		var candidate = get_random_point(player_pos)
		var closest = NavigationServer2D.map_get_closest_point(nav_map, candidate)
		if closest.distance_to(player_pos) >= min_spawn:
			return closest
	return player_pos

func spawn_enemy():
	var spawn_pos = get_valid_spawn(player.global_position)
	var normal_enemy = preload("res://Enemies/normal_enemy.tscn").instantiate()
	var bigger_enemy = preload("res://Enemies/bigger_enemy.tscn").instantiate()
	
	var enemy = normal_enemy
	if randf() < 0.1:
		enemy = bigger_enemy

	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
