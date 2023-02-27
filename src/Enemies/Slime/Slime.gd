tool
extends PatrolEnemy

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

export(Direction) var rotation_direction := Direction.UP setget set_rotation_direction


func set_rotation_direction(value: int) -> void:
	rotation_direction = value
	
	match(rotation_direction):
		Direction.DOWN:
			rotation = deg2rad(180)
			return
		Direction.RIGHT:
			rotation = deg2rad(90)
			return
		Direction.LEFT:
			rotation = deg2rad(270)
			return
		_:
			rotation = deg2rad(0)
			return


func take_damage(source: Hit) -> void:
	stats.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		skin.hit_flash()
		return
	
	var explosion = resource.explosion.instance()
	explosion.rotation_degrees = rotation_degrees
	Global.add_child_to_root(explosion, global_position)
	call_deferred("queue_free")
