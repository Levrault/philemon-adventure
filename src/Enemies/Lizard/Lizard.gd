extends Enemy

const Explosion:PackedScene = preload("res://src/VFX/Explosion.tscn")


func take_damage(source: Hit) -> void:
	.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		return
		
	GameManager.add_child_to_root(Explosion.instance(), global_position)
	call_deferred("queue_free")
