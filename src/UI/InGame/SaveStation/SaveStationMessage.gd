extends Control


func _ready() -> void:
	Events.connect("save_room_enabled", self, "_on_Save_room_enabled")
	$"%Yes".connect("pressed", self, "_on_Yes_pressed")
	$"%No".connect("pressed", self, "_on_No_pressed")
	hide()


func _on_Save_room_enabled() -> void:
	show()
	$AnimationPlayer.play("show")


func _on_Yes_pressed() -> void:
	$AnimationPlayer.play("hide")
	Events.emit_signal("save_data_started")
	Global.unpause_game()
	Serialize.save_data()


func _on_No_pressed() -> void:
	$AnimationPlayer.play("hide")
	Global.unpause_game()
