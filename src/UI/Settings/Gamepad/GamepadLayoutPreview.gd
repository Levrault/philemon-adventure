# Show the current gamepad layout
# Depend on current gamepad biding
# and if left and right stick are inverted
# @category: Gamepad, Field, Rebind
extends Control

const CSV_FILE_PREFIX := "input."

var gamepad_data_buttons_list := []
var gamepad_data_sticks_list := []
var actions := {}
var joystick_actions := {
	"actions": [],
	"translation_key": ""
}


func _ready():
	yield(owner, "ready")
	Events.connect("locale_changed", self, "translate_buttons")
	Events.connect("locale_changed", self, "translate_sticks")


func translate_buttons() -> void:
	for key in actions:
		for data in gamepad_data_buttons_list:
			if data.joy_values.find(actions[key]) == -1:
				continue
			data.action = tr(CSV_FILE_PREFIX + key)


func translate_sticks() -> void:
	for action in joystick_actions.actions:
		for data in gamepad_data_sticks_list:
			if data.joy_values.find(action) != -1:
				data.action = tr(CSV_FILE_PREFIX + joystick_actions.translation_key)
				return
