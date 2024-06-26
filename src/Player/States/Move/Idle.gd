extends State

var transition_enabled := false

onready var jump_input_buffering: Timer = $JumpInputBuffering


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if Input.is_action_pressed(owner.actions.fire):
		_state_machine.transition_to("Move/FiringIdle")
		return
	
	if owner.is_handling_input and owner.is_on_floor() and _parent.get_horizontal_move_direction(owner.actions).x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air", {coyote_time = true})
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.velocity = Vector2.ZERO
	owner.skin.play("idle")

	if not jump_input_buffering.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = true})
		jump_input_buffering.stop()
		return


func exit() -> void:
	_parent.exit()
