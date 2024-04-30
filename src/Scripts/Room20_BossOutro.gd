extends Node2D

const AIR_EXPLOSION = preload("res://src/VFX/AirExplosion.tscn")
const CARD_UPGRADE = preload("res://src/Upgrade/CardUpgrade.tscn")

onready var boss = $"../../Enemies/Boss"
onready var force_field: Node2D = $"../ForceField"
onready var position_2d: Position2D = $Position2D


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("boss_defeated", self, "_on_Boss_defeated")
	Events.connect("boss_explosed", self, "_on_Boss_explosed")


func _on_Boss_defeated() -> void:
	force_field.disabled = true
	Events.emit_signal("player_input_disabled")
	Events.emit_signal("cinematic_transition_started")


func _on_Boss_explosed() -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 1.75
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	Global.add_child_to_root(AIR_EXPLOSION.instance(), position_2d.global_position)
	var card_upgrade = CARD_UPGRADE.instance()
	card_upgrade.type = GameManager.Card.LVL_4
	Global.add_child_to_root(card_upgrade, position_2d.global_position)
	Events.emit_signal("cinematic_transition_ended")
	Events.emit_signal("player_input_enabled")
