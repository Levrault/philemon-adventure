extends State

export(Resource) var projectile_resource


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.connect("animation_finished", self, "_on_Animation_finished")
	owner.skin.connect("attack_triggered", owner.muzzle, "shoot", [projectile_resource])
	owner.skin.play("attack")
	return


func exit() -> void:
	owner.skin.disconnect("attack_triggered", owner.muzzle, "shoot")
	return


func _on_Animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Animation_finished")
	_state_machine.transition_to("Idle")
