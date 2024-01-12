extends PlayerDie

export var delay := 10 


func _on_Screen_exited() -> void:
	owner.queue_free()
	GameMode.call_deferred("add_local_coop_player", owner.device_index, true)
