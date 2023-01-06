extends Node2D


onready var player := get_node("Player") as Player


func _ready() -> void:
	player.connect_camera($Camera)
