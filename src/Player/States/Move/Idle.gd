extends State

onready var jump_input_buffering: Timer = $JumpInputBuffering


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
		owner.skin.play("shoot")
		return
	
	if event.is_action_pressed("slide") and _parent.get_node("Slide").cooldown.is_stopped():
		_state_machine.transition_to("Move/Slide")
		return
	
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_handling_input and owner.is_on_floor() and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air", {coyote_time = true})
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.velocity = Vector2.ZERO
	owner.skin.play("idle")

	if not jump_input_buffering.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = true})
		jump_input_buffering.stop()
		return


func exit() -> void:
	_parent.exit()


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	owner.muzzle.shoot()
	owner.skin.play("idle")
	
