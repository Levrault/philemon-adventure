extends Node

onready var h_box_container = $"%HBoxContainer"


func _ready() -> void:
	set_process_unhandled_input(false)
	h_box_container.hide()
	yield(get_tree().create_timer(3.0), "timeout")
	set_process_unhandled_input(true)
	$CanvasLayer/Control/AnimationPlayer.play("show")


func _unhandled_input(event):
	if event.is_action_pressed("jump_0"):
		Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
		LevelManager.current_level_id = LevelManager.Level.MAIN_MENU
