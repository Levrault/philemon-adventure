# A way to control MusicPlayer singleton with an animationplayer
extends Node2D

export var autostart := false
export var autoplay_track := "menu"
export var delay := 0.0


func _ready() -> void:
	Events.connect("menu_splashcreen_finished", self, "_on_Menu_splashcreen_finished")
	if not autostart:
		return
	if delay > 0:
		yield(get_tree().create_timer(delay), "timeout")
	MusicPlayer.change_track(autoplay_track)


func change_track(track: String) -> void:
	MusicPlayer.change_track(track)


func restart() -> void:
	MusicPlayer.playing = false
	if delay > 0:
		yield(get_tree().create_timer(delay), "timeout")
	MusicPlayer.change_track(autoplay_track)


func play() -> void:
	MusicPlayer.play()


func stop() -> void:
	MusicPlayer.stop()


func _on_Menu_splashcreen_finished() -> void:
	MusicPlayer.change_track(autoplay_track)
	
