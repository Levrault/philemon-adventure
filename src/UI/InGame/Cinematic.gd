extends Control

onready var animation_player = $AnimationPlayer


func _ready():
	Events.connect("cinematic_transition_started", self, "_on_Cinematic_transition_started")
	Events.connect("cinematic_transition_ended", self, "_on_Cinematic_transition_ended")
	animation_player.connect("animation_finished", self, "_on_Animation_finished")


func _on_Cinematic_transition_started() -> void:
	animation_player.play("show")
	

func _on_Cinematic_transition_ended() -> void:
	animation_player.play_backwards("show")


func _on_Animation_finished(anim_name: String) -> void:
	Events.emit_signal("cinematic_animation_finished")
