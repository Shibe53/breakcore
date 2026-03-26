extends Control

@onready var players: Array[Dictionary] = [
	{
		sub_viewport = %LeftSubViewport,
		camera = %LeftCamera,
		player = %P1World/Player1,
		remote_transform = RemoteTransform2D.new()
	},
	{
		sub_viewport = %RightSubViewport,
		camera = %RightCamera,
		player = %P2World/Player2,
		remote_transform = RemoteTransform2D.new()
	},
]
@onready var shader = $ColorRect
@onready var p1_world = %P1World
@onready var p2_world = %P2World

func _ready() -> void:
	for info in players:
		info.remote_transform.remote_path = info.camera.get_path()
		info.player.add_child(info.remote_transform)
		
func _on_switch_signal():
	var p1 = players[0].player
	var p2 = players[1].player
	var p1_pos = p1.position
	var p1_world = p1.get_parent()
	var p1_remote_tf_path = players[0].remote_transform.remote_path
	
	shader.move = true
	p1.position = p2.position
	players[0].remote_transform.remote_path = players[1].remote_transform.remote_path
	p1.reparent(p2.get_parent())
	
	p2.position = p1_pos
	players[1].remote_transform.remote_path = p1_remote_tf_path
	p2.reparent(p1_world)
	
	for child in p1_world.get_children():
		if child is Enemy:
			child.state = child.RECOMPUTE
	
	for child in p2_world.get_children():
		if child is Enemy:
			child.state = child.RECOMPUTE
