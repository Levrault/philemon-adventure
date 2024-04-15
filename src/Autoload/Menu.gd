# Manage menu navigation and historic
# @category: Navigation
extends Node

var history := []
var current_route := ""
var is_splash_screen_viewed = false

func _ready() -> void:
	if OS.has_feature("debug"):
		if ProjectSettings.get_setting("game/skip_boot_screen"):
			is_splash_screen_viewed = true

# Navigate to a new menu
func navigate_to(to: String, transition: String="fade") -> void:
	Events.emit_signal("menu_route_changed", to)
	Events.emit_signal("menu_transition_started", transition)
