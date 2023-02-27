extends State

const ROTATION_BASE := 20.0
export var max_speed := 50.0


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if owner.ray_cast_wall.is_colliding():
		owner.global_position = owner.ray_cast_wall.get_collision_point()
		var normal = owner.ray_cast_wall.get_collision_normal()
		owner.rotation = normal.rotated(deg2rad(90)).angle()
		return
	
	owner.ray_cast_floor.rotation_degrees =- max_speed * 10 * owner.look_direction * delta

	if owner.ray_cast_floor.is_colliding():
		owner.global_position = owner.ray_cast_floor.get_collision_point()
		var normal = owner.ray_cast_floor.get_collision_normal()
		owner.rotation = normal.rotated(deg2rad(90)).angle()
		return
	
	owner.rotation_degrees += ROTATION_BASE * owner.look_direction


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("move")
	owner.ray_cast_floor.enabled = true
	owner.ray_cast_wall.enabled = true


func exit() -> void:
	return
