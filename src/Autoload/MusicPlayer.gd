extends AudioStreamPlayer

const TRANSITION_DURATION := .5

var playlist := {
	"theme": "res://assets/audio/music/DOS-88 - City Stomper.mp3",
	"menu": "res://assets/audio/music/Crash Landing.mp3",
	"boss": "res://assets/audio/music/Race to Mars.mp3",
	"ending": "res://assets/audio/music/DOS-88 - Far away.mp3",
	"upgrade": "res://assets/audio/jingles/victory-fanfare-light-wills-ever-no-drums.ogg",
}

var current: String = ""

onready var tween := $Tween


func _ready() -> void:
	volume_db = linear2db(0)


func change_track(new_music: String, with_transition := true) -> void:
	print_debug("track %s has been changed to %s" % [current, new_music])
	if new_music == current and playing:
		return
	mute()
	current = new_music
	stream = load(playlist[current])
	
	if with_transition:
		volume_db = linear2db(0)
		transition()
		return
	volume_db = linear2db(Config.values.audio.music_volume)
	play()


func transition() -> void:
	tween.interpolate_property(
		self, "volume_db", linear2db(0), linear2db(Config.values.audio.music_volume), TRANSITION_DURATION, Tween.TRANS_SINE, Tween.TRANS_LINEAR
	)
	tween.start()
	play()


func mute() -> void:
	volume_db = linear2db(0)
	tween.stop_all()
	

func resume() -> void:
	transition()
	
