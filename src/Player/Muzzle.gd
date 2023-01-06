extends Position2D

const PlayerBullet:PackedScene = preload("res://src/Projectiles/Bullet.tscn")


func shoot() -> void:
	var instance = PlayerBullet.instance()
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
	instance.direction = owner.look_direction
