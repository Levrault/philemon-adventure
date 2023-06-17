extends State

var transition_enabled := false


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(owner.actions.fire):
		owner.skin.seek(0)
		owner.skin.unfreeze()
		return


func physics_process(delta: float) -> void:
	if owner.is_handling_input and owner.is_on_floor() and _parent.get_horizontal_move_direction(owner.actions).x != 0.0:
		_state_machine.transition_to("Move/FiringRun")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.velocity = Vector2.ZERO
	owner.skin.play("shoot")
	owner.skin.connect("animation_finished", self, "_on_Animation_finished")
	owner.skin.seek(0)
	
	var charged_resource = owner.get_charged_beam_resource()
	if GameManager.is_beam_upgrade_status_unlocked(charged_resource.id):
		owner.skin.freeze()


func exit() -> void:
	_parent.exit()
	owner.skin.unfreeze()
	owner.skin.disconnect("animation_finished", self, "_on_Animation_finished")


func _on_Animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")
