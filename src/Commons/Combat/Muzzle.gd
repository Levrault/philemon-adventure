extends Position2D

var timer:Timer = null


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func reset_cooldown() -> void:
	timer.stop()


func shoot(res: ProjectileResource) -> void:
	if not timer.is_stopped():
		return
	elif res.cooldown > 0:
		timer.wait_time = res.cooldown
		timer.start()
	
	var instance = res.scene.instance()
	Global.add_child_to_root(instance, global_position)
	instance.init(res)
	instance.direction = owner.look_direction
