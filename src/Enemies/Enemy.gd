tool
class_name Enemy
extends Actor

const BATTERY = preload("res://src/Upgrade/Battery.tscn")
export(Resource) var resource
onready var battery_spawn = $BatterySpawn


func _ready() -> void:
	stats.max_health = resource.health
	stats.health = resource.health


func take_damage(source: Hit) -> void:
	.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		skin.hit_flash()
		return
		
	Global.add_child_to_root(resource.explosion.instance(), global_position)
	Global.call_deferred("add_child_to_root", BATTERY.instance(), battery_spawn.global_position)
	call_deferred("queue_free")
