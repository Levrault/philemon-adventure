extends State


export var idle_loop := 3

var loop := 0
var flip := false


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")
	if not owner.is_patrolling:
		return
	owner.skin.connect("animation_finished", self, "_on_Animation_finished")
	
	if "flip" in msg:
		flip = true
	
	if "loop" in msg:
		loop = msg.loop
		return
	
	loop = idle_loop


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Animation_finished")
	
	if flip:
		owner.flip(owner.look_direction * -1)
		flip = false


func _on_Animation_finished(anim_name: String) -> void:
	if loop > 1:
		loop -= 1
		return
	
	_state_machine.transition_to("Patrol")
