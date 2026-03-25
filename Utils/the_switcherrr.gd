extends Node

@onready var qte_1: QTE = $QTE1
@onready var qte_2: QTE = $QTE2

@export var timeout: float = 2
@export var delay_allowed: float = 0.5

var success_p1 = false
var success_p2 = false

signal switch_started1(qte: QTE)
signal switch_started2(qte: QTE)
signal qte_successful_keypress(qte: QTE)
signal switch_success()
signal switch_failure()
	
func _input(event) -> void:
	if event.is_action_pressed("switch"):
		qte_1.on_activate()
		qte_2.on_activate()
		switch_started1.emit(qte_1)
		switch_started2.emit(qte_2)

func _on_qte_success(qte: QTE) -> void:
	if qte.player_num == 1: success_p1 = true
	else: success_p2 = true
	
	if success_p1 and success_p2:
		switch_success.emit()
		success_p1 = false
		success_p2 = false	
		qte_1.deactivate()
		qte_2.deactivate()
	else:
		var timer = get_tree().create_timer(delay_allowed)
		timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	success_p1 = false
	success_p2 = false
	qte_1.deactivate()
	qte_2.deactivate()

func _on_qte_successful_key(qte: QTE, key: Key) -> void:
	qte_successful_keypress.emit(qte)
