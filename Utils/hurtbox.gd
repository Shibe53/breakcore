extends Area2D
class_name Hurtbox

signal invincibility_started
signal invincibility_ended

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape

var guard = false

var invincible = false:
	set(value):
		invincible = value
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_timer_timeout():
	self.invincible = false

func _on_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_invincibility_ended():
	collisionShape.set_deferred("disabled", false)
