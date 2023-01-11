tool
extends Enemy

const Explosion:PackedScene = preload("res://src/VFX/Explosion.tscn")

export var iteration_before_attack := 1

onready var muzzle := $Skin/Muzzle


func take_damage(source: Hit) -> void:
	.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		skin.hit_flash()
		return
		
	GameManager.add_child_to_root(Explosion.instance(), global_position)
	call_deferred("queue_free")
