extends State


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.stats.reset()
	owner.skin.play("spin")

	# check needed since skin value is changed on character change
	if not owner.skin.is_connected("animation_finished", self, "_on_Skin_animation_finished"):
		owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")

	if "spawn_position" in msg:
		owner.position = owner.spawn_position


func exit() -> void:
	owner.is_active = true

	# check needed since skin value is changed on character change
	if owner.skin.is_connected("animation_finished", self, "_on_Skin_animation_finished"):
		owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")
