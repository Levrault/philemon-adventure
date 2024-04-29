extends Node2D

func _ready():
	yield(owner, "ready")
	MusicPlayer.mute()
	MusicPlayer.current = ""
	MusicPlayer.stop()

