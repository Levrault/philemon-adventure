extends Control

var should_change_track: bool = true

func _ready() -> void:
	Events.connect("beam_unlocked", self, "_on_Beam_message_displayed")
	Events.connect("ability_unlocked", self, "_on_Ability_message_displayed")
	Events.connect("card_unlocked", self, "_on_Card_message_displayed")
	$AnimationPlayer.connect("animation_finished", self, "_on_Animation_finished")
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.play_backwards("hide")
		set_process_unhandled_input(false)
		MusicPlayer.resume()


func _on_Beam_message_displayed(beam_type) -> void:
	Global.pause_game()
	show()
	MusicPlayer.change_track("upgrade", false)
	$AnimationPlayer.play("show")
	$"%Message".text = "ingame.%s_unlocked" % GameManager.BeamType.keys()[beam_type].to_lower()


func _on_Ability_message_displayed(ability_type) -> void:
	Global.pause_game()
	MusicPlayer.change_track("upgrade", false)
	show()
	$AnimationPlayer.play("show")
	$"%Message".text = "ingame.%s_unlocked" % GameManager.Ability.keys()[ability_type].to_lower()


func _on_Card_message_displayed(card_type) -> void:
	Global.pause_game()
	MusicPlayer.change_track("upgrade", false)
	if card_type == GameManager.Card.LVL_4:
		should_change_track = false
	show()
	$AnimationPlayer.play("show")
	$"%Message".text = "ingame.%s_unlocked" % GameManager.Card.keys()[card_type].to_lower()


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name != "hide":
		return
	Global.unpause_game()
	hide()
	if should_change_track:
		MusicPlayer.change_track("theme")
	else:
		MusicPlayer.mute()


