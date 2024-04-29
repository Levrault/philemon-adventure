extends Updater


func _ready():
	yield(owner,"ready")
	get_parent().checkbox.connect("toggled", self, "_on_toggled")


func apply(properties: Dictionary, trigger_callback_action := true) -> void:
	if properties.get("enabled", false):
		Events.emit_signal("crt_enabled")
	else:
		Events.emit_signal("crt_disabled")


func _on_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		Events.emit_signal("crt_disabled")
	else:
		Events.emit_signal("crt_enabled")
