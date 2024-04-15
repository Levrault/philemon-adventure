extends AudioStreamPlayer

const TRANSITION_DURATION := 1.5

var playlist := {
	"theme": "res://assets/audio/music/SuperGrottoEscape.ogg",
}

var current: String = "mall"

onready var tween := $Tween


func _ready() -> void:
	volume_db = linear2db(0)


func change_track(new_music: String) -> void:
	print_debug("track %s has been changed to %s" % [current, new_music])
	if new_music == current and playing:
		return
	stop()
	volume_db = linear2db(0)
	current = new_music
	stream = load(playlist[current])
	transition()


func transition() -> void:
	tween.interpolate_property(
		self, "volume_db", linear2db(0), linear2db(Config.values.audio.music_volume), TRANSITION_DURATION, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	tween.start()
	play()
