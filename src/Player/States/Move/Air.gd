extends State

signal jumped

export var acceleration_x := 1000.0
export var min_jump_impulse := 200.0
export var jump_impulse := 275.0
export var max_jump_count := 1

var _jump_count := 1
var _is_controlled := true

onready var _coyote_time: Timer = $CoyoteTime
onready var _impulse_sfx := $Impulse
onready var _bounce_sfx := $Bounce


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_signal("jumped")
		if _jump_count < max_jump_count:
			_impulse_sfx.play_sound()
			jump(jump_impulse / 2)

# TODO: add particules
#			if _jump_count > 1:
#				var dust = dust_scene.instance()
#				owner.get_parent().add_child(dust)
#				dust.position = owner.position
#				dust.emitting = true
		elif _coyote_time.time_left > 0.0:
			_coyote_time.stop()
			_impulse_sfx.play_sound()
			jump(jump_impulse)

	# set a minimal air jump if button is release to soon
	if (
		_is_controlled
		and event.is_action_released("jump")
		and abs(_parent.velocity.y) > min_jump_impulse
		and not _parent.velocity.y > 0
	):
		_parent.velocity.y = -min_jump_impulse

	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	if _parent.velocity.y > 0:
		owner.skin.play("fall")
	elif _parent.velocity.y < 0:
		owner.skin.play("jump")
	
	# Landing
	if not owner.is_on_floor():
		return
	owner.is_snapped_to_floor = true
	var target_state := "Move/Idle" if _parent.get_horizontal_move_direction().x == 0 else "Move/Run"
	_state_machine.transition_to(target_state, {contact = true})


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.acceleration.x = acceleration_x
	owner.is_snapped_to_floor = false
	
	if "ladder" in msg:
		_parent.velocity = Vector2.ZERO
	
	if "coyote_time" in msg:
		_coyote_time.start()
		return
	
	if "impulse" in msg:
		if not "mute_sfx" in msg:
			_impulse_sfx.play_sound()
		jump(jump_impulse)
	
	if "bouncing_force" in msg:
		if not "mute_sfx" in msg:
			_bounce_sfx.play_sound()
		jump(msg.bouncing_force)
		_is_controlled = false

	if "velocity" in msg:
		_parent.velocity = msg.velocity
		return


func exit() -> void:
	_is_controlled = true
	_jump_count = 0
	_parent.acceleration = _parent.acceleration_default
	_parent.exit()


func jump(force: float) -> void:
	_parent.velocity.y = 0
	_parent.velocity += calculate_jump_velocity(force)
	_jump_count += 1


# Returns a new velocity with a vertical impulse applied to it
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(  # replace delta
		_parent.velocity, _parent.max_speed, Vector2(0.0, impulse), Vector2.ZERO, 1.0, Vector2.UP
	)
