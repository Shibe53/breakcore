extends Label

@export_range(1,2) var player_num: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_the_switcherrr_qte_successful_keypress(qte: QTE) -> void:
	pass # Replace with function body.


func _on_the_switcherrr_switch_failure() -> void:
	visible = false


func _on_the_switcherrr_switch_started(qte1: QTE, qte2: QTE) -> void:
	if player_num == qte1.player_num:
		text = qte1.active_recipie_to_string()
	else:
		text = qte2.active_recipie_to_string()
	visible = true


func _on_the_switcherrr_switch_success() -> void:
	visible = false
