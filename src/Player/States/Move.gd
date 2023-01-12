extends State
class_name Move

export var max_speed_default := Vector2(100.0, 325.00)
export var acceleration_default := Vector2(10000, 900.0)
export var decceleration_default := Vector2(10000, 1300.0)
export var max_speed_fall := 275.00

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO


static func get_vertical_move_direction() -> Vector2:
	return Vector2(
		1.0, Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


static func get_horizontal_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
	)


static func calculate_velocity(
	old_velocity: Vector2,
	current_max_speed: Vector2,
	current_acceleration: Vector2,
	current_decceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	current_max_speed_fall := 1500.00
) -> Vector2:
	var new_velocity := old_velocity
	new_velocity.y += move_direction.y * current_acceleration.y * delta

	if move_direction.x:
		new_velocity.x += move_direction.x * current_acceleration.x * delta
	elif abs(new_velocity.x) > 0.1:
		new_velocity.x -= current_decceleration.x * delta * sign(new_velocity.x)
		new_velocity.x = new_velocity.x if sign(new_velocity.x) == sign(old_velocity.x) else 0.0

	new_velocity.x = clamp(new_velocity.x, -current_max_speed.x, current_max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -current_max_speed.y, current_max_speed_fall)

	return new_velocity


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor():
		if event.is_action_pressed("jump"):
			print_debug("jump from move")
			_state_machine.transition_to("Move/Air", {impulse = true})
			return

	if owner.flag.ladder and not owner.flag.ladder_one_way_platform:
		if event.is_action_pressed("move_up"):
			_state_machine.transition_to("Climbing")
			return
	
	if owner.flag.ladder_one_way_platform:
		if event.is_action_pressed("move_down"):
			_state_machine.transition_to("Climbing", { climb_from_top = true })
			return


func physics_process(delta: float) -> void:
	var direction := get_horizontal_move_direction()

	if not owner.is_handling_input:
		direction.x = 0

	owner.flip(direction.x)

	velocity = calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, direction
	)

	if owner.is_snapped_to_floor:
		if owner.is_on_moving_platform and (_state_machine.state_name != "Air" and velocity.y > 0):
			velocity.y = 0

		velocity = owner.move_and_slide_with_snap(
			velocity, owner.SNAP, owner.FLOOR_NORMAL, owner.stop_on_slope
		)
	else:
		velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

	Events.emit_signal("player_moved", owner)


func enter(msg: Dictionary = {}) -> void:
	$Air.connect("jumped", $Idle.jump_input_buffering, "start")


func exit() -> void:
	$Air.disconnect("jumped", $Idle.jump_input_buffering, "start")


func throwback(throwback_force: Vector2) -> void:
	velocity.y = 0
	var impulse := Vector2(throwback_force.x * owner.hit_direction, throwback_force.y)
	velocity += calculate_velocity(
		velocity, max_speed, impulse, Vector2.ZERO, 1.0, Vector2.UP
	)
