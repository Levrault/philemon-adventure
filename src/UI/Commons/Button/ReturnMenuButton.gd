extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("in_game_menu_hidden")
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
	LevelManager.current_level_id = LevelManager.Level.MAIN_MENU
	Menu.navigate_to("TitleScreen")
	MusicPlayer.change_track("menu")
