extends State

export var max_speed_default := Vector2(100.0, 325.00)
export var acceleration_default := Vector2(10000, 900.0)
export var decceleration_default := Vector2(10000, 1300.0)
export var max_speed_fall := 275.00

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO


func physics_process(delta: float) -> void:
	var direction := Vector2(1, 0)

	owner.flip(direction.x)

	velocity = Move.calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, direction
	)
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("run")
