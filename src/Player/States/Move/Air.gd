extends State

signal jumped

var LandDust := preload("res://src/VFX/LandDust.tscn")

export var acceleration_x := 1000.0
export var min_jump_impulse := 200.0
export var jump_impulse := 275.0
export var max_jump_count := 0

var _jump_count := 1
var _is_controlled := true

onready var _coyote_time: Timer = $CoyoteTime
onready var _impulse_sfx := $Impulse
onready var _bounce_sfx := $Bounce


func _ready() -> void:
	Events.connect("ability_unlocked", self, "_on_Ability_unlocked")
	
	if GameManager.is_ability_upgrade_status_unlocked(GameManager.Ability.JUMP):
		max_jump_count = 1
	
	if GameManager.is_ability_upgrade_status_unlocked(GameManager.Ability.DOUBLE_JUMP):
		max_jump_count = 2


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(owner.actions.jump):
		if _jump_count < max_jump_count:
			emit_signal("jumped")
			_impulse_sfx.play_sound()
			jump(jump_impulse - 75.0)

			if _jump_count > 1:
				Global.add_child_to_root(LandDust.instance(), owner.global_position)
		if _coyote_time.time_left > 0.0:
			if _jump_count < max_jump_count:
				emit_signal("jumped")
				_coyote_time.stop()
				_impulse_sfx.play_sound()
				jump(jump_impulse)

	# set a minimal air jump if button is release to soon
	if (
		_is_controlled
		and event.is_action_released(owner.actions.jump)
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
	var target_state := "Move/Idle" if _parent.get_horizontal_move_direction(owner.actions).x == 0 else "Move/Run"
	_state_machine.transition_to(target_state, {contact = true})
	Global.add_child_to_root(LandDust.instance(), owner.global_position)


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
		Global.add_child_to_root(LandDust.instance(), owner.global_position)
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


func _on_Ability_unlocked(ability_type: int) -> void:
	if ability_type == GameManager.Ability.JUMP:
		max_jump_count = 1
		return
	
	if ability_type != GameManager.Ability.DOUBLE_JUMP:
		max_jump_count = 2
		return
