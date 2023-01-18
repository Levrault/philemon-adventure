extends Node2D


onready var player := get_node("Player") as Player
onready var spawns := get_node("Spawns")


func _ready() -> void:
	# Init player
	player.connect_camera($Camera)
	
	if spawns.has_node(LevelManager.spawn_point):
		player.global_position = spawns.get_node(LevelManager.spawn_point).global_position
	
	if LevelManager.last_look_direction_of_player != 0:
		player.flip(LevelManager.last_look_direction_of_player)
