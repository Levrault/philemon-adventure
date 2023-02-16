class_name Patrol
extends State


export var max_speed_default := Vector2(75.0, 275.00)
export var acceleration_default := Vector2(10000, 800.0)
export var decceleration_default := Vector2(10000, 300.0)
export var max_speed_fall := 300.00
export var loop := 2

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if owner.ray_cast_wall.is_colliding() or not owner.ray_cast_floor.is_colliding():
		_state_machine.transition_to("Idle", { loop = loop, flip = true })
	
	velocity = Move.calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, Vector2(owner.look_direction, 1.0)
	)
	velocity = owner.move_and_slide_with_snap(velocity, owner.SNAP, Vector2.UP, owner.stop_on_slope)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("move")
	owner.ray_cast_wall.enabled = true
	owner.ray_cast_floor.enabled = true


func exit() -> void:
	owner.ray_cast_wall.enabled = false
	owner.ray_cast_floor.enabled = false
