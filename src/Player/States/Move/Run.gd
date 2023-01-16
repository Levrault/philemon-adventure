extends State

var transition_enabled := false

onready var transition_interval := $TransitionInterval


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and GameManager.is_beam_upgrade_status_unlocked(GameManager.BeamType.BEAM):
		transition_interval.start()
		owner.skin.play("run_shoot")
		owner.muzzle.shoot(owner.get_current_beam_resource())
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
	owner.skin.connect("animation_finished", self, "_on_Animation_finished")
	transition_interval.connect("timeout", self, "_on_Timeout")


func exit() -> void:
	_parent.exit()
	owner.skin.disconnect("animation_finished", self, "_on_Animation_finished")
	transition_interval.disconnect("timeout", self, "_on_Timeout")


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "run_shoot" and transition_enabled:
		owner.skin.play("run")
		transition_enabled = false


func _on_Timeout() -> void:
	transition_enabled = true
