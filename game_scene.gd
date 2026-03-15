extends Control

@onready var players: Array[Dictionary] = [
	{
		sub_viewport = %LeftSubViewport,
		camera = %LeftCamera,
		player = %P1World/Player1,
	},
	{
		sub_viewport = %RightSubViewport,
		camera = %RightCamera,
		player = %P2World/Player2,
	},
]

func _ready() -> void:
	for info in players:
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = info.camera.get_path()
		info.player.add_child(remote_transform)
