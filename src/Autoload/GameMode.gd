extends Node

enum PlayerSkin {
	ORANGE,
	RED,
	BLUE,
	PINK
}

var coop_skins := {}

var CoopPlayerSpawnPoint := preload("res://src/Multiplayer/Spawn/CoopPlayerSpawnPoint.tscn")
var CoopPlayerScene := preload("res://src/Multiplayer/Players/CoopPlayer.tscn")
var coop_player_1_spawn_location: Position2D = null
var coop_player_2_spawn_location: Position2D = null
var coop_player_3_spawn_location: Position2D = null
var coop_player_1_portal_spawn_location: Position2D = null
var coop_player_2_portal_spawn_location: Position2D = null
var coop_player_3_portal_spawn_location: Position2D = null
var coop_players := []

func add_local_coop_player(device_index: int, active_delay := false) -> void:
	var coop_player_spawn_point := CoopPlayerSpawnPoint.instance()
	coop_player_spawn_point.device_index = device_index
	if active_delay:
		coop_player_spawn_point.active_delay()
	
	var spawn_location: Position2D = null
	if device_index == 1:
		spawn_location = coop_player_1_spawn_location
	elif device_index == 2:
		spawn_location = coop_player_2_spawn_location
	else:
		spawn_location = coop_player_3_spawn_location
		
	coop_player_spawn_point.target = spawn_location
	Global.add_child_to_root(coop_player_spawn_point, spawn_location.global_position)


func persistant_local_player(device_index: int, active_delay := false) -> void:
	var coop_player := CoopPlayerScene.instance()
	
	var spawn_location: Position2D = null
	if device_index == 1:
		spawn_location = coop_player_1_portal_spawn_location
	elif device_index == 2:
		spawn_location = coop_player_2_portal_spawn_location
	else:
		spawn_location = coop_player_3_portal_spawn_location
	
	Global.add_child_to_root(coop_player, spawn_location.global_position)
	coop_player.device_index = device_index
	coop_player.flip(LevelManager.last_look_direction_of_player)
	

func remove_local_coop_player(device_index: int) -> void:
	coop_players.erase(device_index)
	Events.emit_signal("coop_player_removed", device_index)
