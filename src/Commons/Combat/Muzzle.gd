extends Position2D

export(Resource) var projectile_data


func shoot(res: ProjectileResource) -> void:
	var instance = projectile_data.scene.instance()
	GameManager.add_child_to_root(instance, global_position)
	instance.init(res)
	instance.direction = owner.look_direction
