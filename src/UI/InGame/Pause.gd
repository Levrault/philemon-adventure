extends Node

onready var in_game_screen_page := owner.get_node("InGameScreenPage")


func _ready() -> void:
	Events.connect("in_game_menu_hidden", self, "unpause")
	owner.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("pause_0") and not get_tree().paused:
		pause()


func pause() -> void:
	owner.visible = true
	get_tree().paused = true
	in_game_screen_page.focus_default_field()
	set_process_input(false)
	Global.pause_game()
	Engine.time_scale = 1.0


func unpause() -> void:
	owner.visible = false
	get_tree().paused = false
	set_process_input(true)
	Global.unpause_game()
	Engine.time_scale = Config.values.accessibility.time_scale
