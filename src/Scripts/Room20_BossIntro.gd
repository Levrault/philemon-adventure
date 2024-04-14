extends Node2D

onready var boss = $"../../Enemies/Boss"
onready var animation_player = $AnimationPlayer
onready var trigger_zone = $TriggerZone
onready var force_field = $ForceField


func _ready() -> void:
	yield(owner, "ready")
	if OS.has_feature("debug"):
		if ProjectSettings.get_setting("game/skip_boss_cinematic"):
			trigger_zone.queue_free()
			boss.active()
			return
	
	trigger_zone.connect("body_entered", self, "_on_Trigger_zone_body_entered")
	force_field.disabled = true
	animation_player.play("sequence_00")
	animation_player.connect("animation_finished", self, "_on_Animation_finished")



func display_text() -> void:
	Events.emit_signal("cinematic_text_displayed", "ingame.boss")


func _on_Trigger_zone_body_entered(body: Node) -> void:
	if not body is Player:
		return
	Events.emit_signal("player_input_disabled")
	force_field.disabled = false
	Events.connect("cinematic_animation_finished", self, "_on_Cinematic_animation_finished")
	Events.emit_signal("cinematic_transition_started")
	trigger_zone.queue_free()


func _on_Cinematic_animation_finished() -> void:
	animation_player.play("sequence_01")


func _on_Cinematic_ended() -> void:
	Events.emit_signal("player_input_enabled")
	boss.active()


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "sequence_01":
		Events.disconnect("cinematic_animation_finished", self, "_on_Cinematic_animation_finished")
		Events.connect("cinematic_animation_finished", self, "_on_Cinematic_ended")
		animation_player.disconnect("animation_finished", self, "_on_Animation_finished")
		Events.emit_signal("cinematic_transition_ended")
