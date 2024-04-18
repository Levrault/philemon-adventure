extends Node

onready var h_box_container = $"%HBoxContainer"


func _ready() -> void:
	set_process_unhandled_input(false)
	h_box_container.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	set_process_unhandled_input(true)
	$CanvasLayer/Control/AnimationPlayer.play("show")


func _unhandled_input(event):
	if event.is_action_pressed("jump_0"):
		Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
		LevelManager.current_level_id = LevelManager.Level.keys().find(Serialize.get_current_profile().progression.last_saveroom)
		return
	if event.is_action_pressed("ui_cancel"):
		Events.emit_signal("in_game_menu_hidden")
		Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
		LevelManager.current_level_id = LevelManager.Level.MAIN_MENU
		Menu.navigate_to("TitleScreen")
		return
