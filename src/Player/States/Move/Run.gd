extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
		owner.skin.play("run_shoot")
		owner.muzzle.shoot()
		return
	
	if event.is_action_pressed("slide") and _parent.get_node("Slide").cooldown.is_stopped():
		_state_machine.transition_to("Move/Slide", { max_force = true })
		return
	
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.max_speed.x = _parent.max_speed_default.x
	if owner.is_on_floor():
		if _parent.velocity.length() < 1.0 and not owner.is_on_wall():
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air", {coyote_time = true})
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	owner.skin.play("run")


func exit() -> void:
	_parent.exit()


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.play("run")
	
