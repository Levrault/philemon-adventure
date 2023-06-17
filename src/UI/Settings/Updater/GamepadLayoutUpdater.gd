extends Updater

const CUSTOM_LAYOUT = "custom"
var previous_actions := []


func apply(properties: Dictionary, trigger_callback_action := true) -> void:
	Events.emit_signal("gamepad_layout_changed")
