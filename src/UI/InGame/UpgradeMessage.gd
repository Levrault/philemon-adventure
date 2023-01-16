extends Control


func _ready() -> void:
	Events.connect("beam_unlocked", self, "_on_Beam_message_displayed")
	Events.connect("ability_unlocked", self, "_on_Ability_message_displayed")
	$AnimationPlayer.connect("animation_finished", self, "_on_Animation_finished")
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$AnimationPlayer.play_backwards("hide")
		set_process_unhandled_input(false)


func _on_Beam_message_displayed(beam_type) -> void:
	GameManager.pause_game()
	show()
	$AnimationPlayer.play("show")
	$"%Message".text = "upgrade.%s_unlocked" % GameManager.BeamType.keys()[beam_type].to_lower()


func _on_Ability_message_displayed(ability_type) -> void:
	GameManager.pause_game()
	show()
	$AnimationPlayer.play("show")
	$"%Message".text = "upgrade.%s_unlocked" % GameManager.Ability.keys()[ability_type].to_lower()


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name != "hide":
		return
	GameManager.unpause_game()
	hide()
