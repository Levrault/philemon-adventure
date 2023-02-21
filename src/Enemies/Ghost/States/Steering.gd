extends State


export var steering_loop := 3
var loop := 0


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("steering")
	owner.skin.connect("animation_finished", self, "_on_Animation_finished")
	
	loop = steering_loop


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Animation_finished")


func _on_Animation_finished(anim_name: String) -> void:
	if loop > 1:
		loop -= 1
		return
	_state_machine.transition_to("Chasing")
