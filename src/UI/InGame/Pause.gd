extends Node

onready var in_game_screen_page := owner.get_node("InGameScreenPage")

var blocked_levels := [LevelManager.Level.MAIN_MENU, LevelManager.Level.INTRO, LevelManager.Level.ENDING, LevelManager.Level.GAME_OVER]

func _ready() -> void:
	yield(owner, "ready")
	Events.connect("in_game_menu_hidden", self, "unpause")
	owner.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("pause_0") and not get_tree().paused and not blocked_levels.has(LevelManager.current_level_id):
		pause()
		return
	if event.is_action_pressed("pause_0") and get_tree().paused and not blocked_levels.has(LevelManager.current_level_id):
		unpause()
		return


func pause() -> void:
	Menu.history.clear()
	Menu.navigate_to(in_game_screen_page.get_name())
	Menu.current_route = in_game_screen_page.get_name()
	Global.pause_game()
	owner.visible = true
	in_game_screen_page.last_clicked_button = in_game_screen_page.default_field_to_focus
	in_game_screen_page.show()
	in_game_screen_page.focus_default_field()
	Engine.time_scale = 1.0
	Events.emit_signal("menu_transition_started")


func unpause() -> void:
	Menu.history.clear()
	owner.visible = false
	Global.unpause_game()
	Engine.time_scale = Config.values.accessibility.time_scale
