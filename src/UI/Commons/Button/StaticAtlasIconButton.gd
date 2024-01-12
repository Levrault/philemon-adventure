extends Button

export var action := "jump"
export var device := InputManager.DEVICE_XBOX_CONTROLLER


func _ready():
	var joy_string := InputManager.get_device_button_from_action(action, device)
	icon = InputManager.get_device_icon_texture_from_action(joy_string, device)


