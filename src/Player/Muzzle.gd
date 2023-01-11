extends Position2D

const PlayerBullet:PackedScene = preload("res://src/Projectiles/Bullet.tscn")


func shoot() -> void:
	var instance = PlayerBullet.instance()
	GameManager.add_child_to_root(instance, global_position)
	instance.direction = owner.look_direction
