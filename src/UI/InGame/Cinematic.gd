extends Control

onready var animation_player = $AnimationPlayer
onready var animation_player_2 = $AnimationPlayer2

onready var label = $Label


func _ready():
	Events.connect("cinematic_transition_started", self, "_on_Cinematic_transition_started")
	Events.connect("cinematic_ending_transition_started", self, "_on_Cinematic_ending_transition_started")
	Events.connect("cinematic_transition_ended", self, "_on_Cinematic_transition_ended")
	Events.connect("cinematic_text_displayed", self, "_on_Cinematic_text_displayed")
	animation_player.connect("animation_finished", self, "_on_Animation_finished")
	label.hide()


func _on_Cinematic_transition_started() -> void:
	animation_player.play("show")
	

func _on_Cinematic_transition_ended() -> void:
	animation_player.play_backwards("show")


func _on_Cinematic_ending_transition_started() -> void:
	animation_player.play("ending")


func _on_Cinematic_text_displayed(text: String) -> void:
	label.text = tr(text)
	animation_player_2.play("text")


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "show" or anim_name == "ending":
		Events.emit_signal("cinematic_animation_finished")
