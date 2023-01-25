extends Control


func _ready() -> void:
	Events.connect("popup_displayed", self, "_on_Popup_displayed")
	set_process_unhandled_input(false)
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		Global.unpause_game()
		hide()
		set_process_unhandled_input(false)


func _on_Popup_displayed(text: String) -> void:
	Global.pause_game()
	$"%Message".text = tr(text)
	show()
	$AnimationPlayer.play("show")
	$AudioStreamPlayer.play()
