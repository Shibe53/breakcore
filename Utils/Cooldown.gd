extends Timer
class_name Cooldown

signal entered_cooldown(cd: Cooldown)
signal exited_cooldown(cd: Cooldown)

func start_cd(time :float = -1):
	self.start(time)
	entered_cooldown.emit(self)
	
func on_cd() -> bool:
	return not self.is_stopped()

func remaining() -> float:
	return self.time_left

func _on_timeout() -> void:
	exited_cooldown.emit(self)
