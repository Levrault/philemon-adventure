class_name Shield
extends Node2D


onready var stats = $Stats


export(Resource) var resource


func _ready() -> void:
	stats.max_health = resource.health
	stats.health = resource.health


func take_damage(source: Hit) -> void:
	stats.take_damage(source)
	call_deferred("queue_free")
