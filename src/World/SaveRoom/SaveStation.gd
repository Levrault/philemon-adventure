class_name SaveStation
extends Node2D

const PLATFORM_ADD_ACTIVE := 5
const PLATFORM_FLOATING_ADD := 3

var has_player := false
var platform_starting_position := Vector2.ZERO
var platform_active_position := Vector2.ZERO

onready var tween := $Tween
onready var platform := $Platform
onready var anim := $AnimationPlayer


func _ready() -> void:
	Events.connect("save_data_started", self, "_on_Save_data_started")
	Events.connect("player_spawned", self, "_on_Player_spawned")
	tween.connect("tween_all_completed", self, "_on_Activation_tween_all_completed")
	anim.play("unused")
	platform_starting_position = platform.position
	platform_active_position = Vector2(platform.position.x, platform.position.y + PLATFORM_ADD_ACTIVE)


func active_save_station() -> void:
	has_player = true
	tween.interpolate_property(platform, "position", platform.position, platform_active_position, 1.0, Tween.TRANS_SINE)
	tween.start()


func inactive_save_station() -> void:
	has_player = false
	tween.stop_all()
	tween.remove_all()
	tween.interpolate_property(platform, "position", platform.position, platform_starting_position, .5, Tween.TRANS_SINE)
	tween.start()


func spawn_player() -> void:
	platform.position = platform_active_position
	Events.emit_signal("player_teleported_to", $PlayerPosition.global_position)
	Events.emit_signal("player_state_changed_to", "Spawn", { respawn = true })
	$AudioStreamPlayer.play()


func _on_Activation_tween_all_completed() -> void:
	if not GameManager.player_status == GameManager.PlayerStatus.alive:
		GameManager.player_status = GameManager.PlayerStatus.alive
		return
	if not has_player:
		return
	Global.pause_game()
	Events.emit_signal("save_room_enabled")


func _on_Save_data_started() -> void:
	Events.emit_signal("player_teleported_to", $PlayerPosition.global_position)
	anim.play("completed")
	$AudioStreamPlayer.play()


func _on_Player_spawned() -> void:
	$AudioStreamPlayer.stop()
