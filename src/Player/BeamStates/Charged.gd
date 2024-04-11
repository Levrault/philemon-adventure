extends State

const DELAY := 0.1

var tween : SceneTreeTween = null


func unhandled_input(event: InputEvent) -> void:
	if not owner.is_on_floor():
		_state_machine.transition_to("Cancel")
		return
	if event.is_action_released(owner.actions.fire):
		owner.muzzle.shoot(owner.get_charged_beam_resource())
		_state_machine.transition_to("Firing")
		return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	tween = create_tween().set_loops()
	tween.tween_property(owner.skin, "modulate", Color.red, DELAY)
	tween.tween_interval(DELAY)
	tween.tween_property(owner.skin, "modulate", Color.white,DELAY)


func exit() -> void:
	tween.stop()
	var exit_tween = create_tween()
	exit_tween.tween_property(owner.skin, "modulate", Color.red, DELAY)
	exit_tween.tween_interval(DELAY * 2)
	exit_tween.tween_property(owner.skin, "modulate", Color.white, DELAY * 2)
