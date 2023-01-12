extends Position2D

export(Resource) var projectile_data

var timer:Timer = null


func _ready() -> void:
	if projectile_data.cooldown > 0:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = projectile_data.cooldown
		add_child(timer)


func shoot(res: ProjectileResource) -> void:
	if timer != null:
		if not timer.is_stopped():
			return
		timer.start()
		
	var instance = projectile_data.scene.instance()
	GameManager.add_child_to_root(instance, global_position)
	instance.init(res)
	instance.direction = owner.look_direction
