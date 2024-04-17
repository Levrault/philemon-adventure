extends Area2D



func _ready():
	connect("body_entered", self, "_on_Body_entered")


func _on_Body_entered(body: Node) -> void:
	if not body is Player:
		return
	Events.emit_signal("player_input_disabled")
	Events.connect("cinematic_animation_finished", self, "_on_Cinematic_animation_finished")
	Events.emit_signal("cinematic_ending_transition_started")


func _on_Cinematic_animation_finished() -> void:
	LevelManager.current_level_id = LevelManager.Level.ENDING
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
