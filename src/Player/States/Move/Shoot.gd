extends State


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.velocity = Vector2.ZERO
	owner.skin.play("shoot")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func exit() -> void:
	_parent.exit()


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	owner.muzzle.shoot()
	_state_machine.transition_to("Move/Idle")
	
