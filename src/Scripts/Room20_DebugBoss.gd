extends Node2D

onready var boss: KinematicBody2D = $"../../Enemies/Boss"
onready var timer: Timer = $Timer


func _ready() -> void:
	yield(owner, "ready")
	if OS.has_feature("debug"):
		if ProjectSettings.get_setting("game/kill_boss"):
			timer.connect("timeout", self, "_on_timeout")
			timer.start()
			return
	queue_free()


func _on_timeout() -> void:
	var damage := DamageSource.new()
	damage.damage = 10000
	damage.is_instakill = true
	boss.take_damage(Hit.new(damage))
	
