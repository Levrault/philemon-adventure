extends State

const DELAY := 0.02
var tween : SceneTreeTween = null

onready var timer := $Timer
onready var audio_stream_player = $AudioStreamPlayer


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(owner.actions.fire):
		_state_machine.transition_to("Firing")
		return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	timer.connect("timeout", self, "_on_Timeout")
	audio_stream_player.pitch_scale = 4
	audio_stream_player.play()
	timer.wait_time = owner.get_charged_beam_resource().charged_wait_time
	timer.start()
	tween = create_tween().set_loops()
	tween.tween_property(owner.skin, "modulate", Color.red, DELAY)
	tween.tween_interval(DELAY)
	tween.tween_property(owner.skin, "modulate", Color.white,DELAY)


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout")
	tween.stop()
	var exit_tween = create_tween()
	exit_tween.tween_property(owner.skin, "modulate", Color.white,DELAY)


func _on_Timeout() -> void:
	_state_machine.transition_to("Charged")
