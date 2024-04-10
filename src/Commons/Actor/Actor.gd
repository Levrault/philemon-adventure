# Should be seen has an abstract class
# Every character that can fight should inherit from it
tool
class_name Actor
extends KinematicBody2D

export (int, -2, 2, 4) var look_direction := 1 setget set_look_direction
export(Resource) var resource


var is_snapped_to_floor := false
var stop_on_slope := true
var hit_direction := 1.0


onready var stats: Stats = $Stats as Stats
onready var state_machine: StateMachine = $StateMachine
onready var skin: Node2D = $Skin


func _ready() -> void:
	flip(look_direction)
	stats.max_health = resource.health
	stats.health = resource.health


func take_damage(source: Hit) -> void:
	.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		skin.hit_flash()
		return
		
	Global.add_child_to_root(resource.explosion.instance(), global_position)
	call_deferred("queue_free")


func set_look_direction(value: int) -> void:
	look_direction = value
	
	if Engine.editor_hint:
		flip(look_direction)


func flip(direction:int = 0) -> void:
	if direction == 0 :
		return
	look_direction = int(sign(direction))
	skin.scale.x = look_direction
