extends State


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("take_damage")
	Events.emit_signal("boss_defeated")


func exit() -> void:
	return
