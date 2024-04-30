extends Player
class_name CoopPlayer

var Explosion := preload("res://src/VFX/AirExplosion.tscn")
var skin_texture_id = GameMode.PlayerSkin.BLUE


func _ready() -> void:
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed(actions.coop_respawn):
		_on_Coop_player_removed(device_index)
		GameMode.call_deferred("add_local_coop_player", device_index, true)
		return

	if event.is_action_pressed(actions.pause):
		Events.emit_signal("popup_coop_displayed", device_index)
		return


func set_device_index(p_device_index: int) -> void:
	device_index = p_device_index
	$PlayerIndicator.text = "P%s" % (device_index + 1)
	$Skin.set_skin_by_device_index(device_index)
	actions = {
		"move_up": "move_up_%s" % device_index,
		"move_down": "move_down_%s" % device_index,
		"move_right": "move_right_%s" % device_index,
		"move_left": "move_left_%s" % device_index,
		"jump": "jump_%s" % device_index,
		"fire": "fire_%s" % device_index,
		"fire_mode": "fire_mode_%s" % device_index,
		"coop_respawn": "coop_respawn_%s" % device_index,
		"pause": "pause_%s" % device_index,
	}
	set_process_input(true)


func _on_Coop_player_removed(index: int) -> void:
	if device_index != index:
		return
	
	var explosion = Explosion.instance()
	Global.add_child_to_root(explosion, global_position)
	call_deferred("queue_free")
