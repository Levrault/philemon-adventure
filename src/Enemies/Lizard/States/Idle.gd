extends State

onready var timer := $Timer


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")
	timer.wait_time = owner.skin.anim.current_animation_length * owner.iteration_before_attack
	timer.connect("timeout", self, "_on_Timeout")
	timer.start()


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout")
	timer.stop()


func _on_Timeout() -> void:
	_state_machine.transition_to("Attack")
