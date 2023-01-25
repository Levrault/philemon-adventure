extends State

const STATION_ROOM_LOOP := 10


func flash() -> void:
	var length: float = owner.skin.get_animation("spin").length
	var delay := (length / STATION_ROOM_LOOP) / 3
	var tween = create_tween().set_loops(STATION_ROOM_LOOP)
	tween.tween_property(owner.skin.sprite.get_material(), "shader_param/active", true, delay)
	tween.tween_interval(delay)
	tween.tween_property(owner.skin.sprite.get_material(), "shader_param/active", false, delay)


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.stats.reset()
	owner.skin.play("spin")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")

	if "spawn_position" in msg:
		owner.position = owner.spawn_position

	if "respawn" in msg:
		flash()

	if "saving_data" in msg:
		owner.skin.connect("animation_finished", self, "_on_Saving_data_animation_finished")
		flash()


func exit() -> void:
	owner.is_active = true
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")
	Events.emit_signal("player_spawned")


func _on_Saving_data_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Saving_data_animation_finished")
	Events.emit_signal("popup_displayed", "ingame.save_data_completed")
