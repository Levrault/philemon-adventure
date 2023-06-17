extends Control

var current_device_index := -1

func _ready() -> void:
	Events.connect("popup_coop_displayed", self, "_on_Popup_displayed")
	set_process_unhandled_input(false)
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if current_device_index == -1:
		return

	if event.is_action("cancel_%s" % current_device_index):
		Global.unpause_game()
		hide()
		set_process_unhandled_input(false)
		return
		
	if event.is_action("jump_%s" % current_device_index):
		GameMode.remove_local_coop_player(current_device_index)
		current_device_index = -1
		Global.unpause_game()
		hide()
		set_process_unhandled_input(false)
		return


func _on_Popup_displayed(device_index: int) -> void:
	current_device_index = device_index
	Global.pause_game()
	$"%Message".text = tr("commons.quit_coop").format({device_index = device_index})
	show()
	$AnimationPlayer.play("show")
	$AudioStreamPlayer.play()
