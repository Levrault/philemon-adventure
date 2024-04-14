extends Node2D

const AIR_EXPLOSION = preload("res://src/VFX/AirExplosion.tscn")

var index := 0
var explosions = []

onready var timer: Timer = $Timer
onready var animation_length: Timer = $AnimationLength


func _ready() -> void:
	Events.connect("boss_defeated", self, "_on_Boss_defeated")
	timer.connect("timeout", self, "_on_Timeout")
	animation_length.connect("timeout", self, "_on_Animation_length_timeout")
	for child in get_children():
		if child is Position2D:
			explosions.append(child)


func _on_Boss_defeated() -> void:
	Events.connect("cinematic_animation_finished", self, "_on_Cinematic_animation_finished")


func _on_Timeout() -> void:
	index += 1
	if index > explosions.size() - 1:
		index = 0
	Global.add_child_to_root(AIR_EXPLOSION.instance(), explosions[index].global_position)


func _on_Animation_length_timeout() -> void:
	timer.stop()
	for explosion in explosions:
		Global.add_child_to_root(AIR_EXPLOSION.instance(), explosion.global_position)
	owner.queue_free()
	Events.emit_signal("boss_explosed")


func _on_Cinematic_animation_finished() -> void:
	explosions[index].add_child(AIR_EXPLOSION.instance())
	timer.start()
	animation_length.start()
