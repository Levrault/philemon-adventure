extends State

export var max_speed := 200

var velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if owner.target.global_position.distance_to(owner.global_position) < 5:
		if owner.target != owner.middle_attack_position:
			owner.flip(-1)
		_state_machine.transition_to("Attack")
		return
	
	var target_global_position :Vector2 = owner.target.global_position
	var direction = owner.global_position.direction_to(target_global_position)

	var desiredvelocity = direction * (max_speed * owner.speed_multiplier)
	var steering = (desiredvelocity - velocity) * delta * 4.0
	velocity += steering
	velocity = owner.move_and_slide(velocity)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")


func exit() -> void:
	return

