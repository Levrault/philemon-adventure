extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(owner.actions.fire):
		_state_machine.transition_to("Firing", { firing = true })
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.modulate = Color.white


func exit() -> void:
	return
