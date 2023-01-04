extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
		owner.skin.play("duck_shoot")
		return
	
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if Input.is_action_pressed("duck"):
		return
	
	if Input.is_action_just_released("duck"):
		_state_machine.transition_to("Move/Idle")
		return
	
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	owner.skin.play("duck_transition")


func exit() -> void:
	_parent.exit()


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	owner.muzzle_duck.shoot()
	owner.skin.play("duck")
