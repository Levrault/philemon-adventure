tool
extends Node2D


export(GameManager.Card) var type := GameManager.Card.LVL_1 setget set_type
var is_active := true
var disabled := false setget set_disabled
onready var area = $Area2D


func _ready() -> void:
	Events.connect("card_unlocked", self, "_on_Card_unlocked")
	area.connect("body_entered", self, "_on_Body_entered")
	area.connect("body_exited", self, "_on_Body_exited")
	set_type(type)
	$CardSprite.visible = false
	if GameManager.is_card_upgrade_status_unlocked(type):
		is_active = false


func set_type(p_type: int) -> void:
	type = p_type
	if type == GameManager.Card.LVL_1:
		$Sprite.modulate = Color("#a3ce27")
		$CardSprite.frame = 1
		return
	if type == GameManager.Card.LVL_2:
		$Sprite.modulate = Color("#007899")
		$CardSprite.frame = 3
		return
	if type == GameManager.Card.LVL_3:
		$Sprite.modulate = Color("#be2633")
		$CardSprite.frame = 2
		return
	if type == GameManager.Card.LVL_4:
		$Sprite.modulate = Color("#000000")
		$CardSprite.frame = 0
		return


func set_disabled(value: bool) -> void:
	disabled = value
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", disabled)
	visible = not disabled


func _on_Card_unlocked(card_type) -> void:
	if card_type != type:
		return
	is_active = false


func _on_Body_entered(body: Node) -> void:
	if not body is Player:
		return
	if is_active:
		$CardAnimationPlayer.play("on")
		return
	$AnimationPlayer.play("off")


func _on_Body_exited(body: Node) -> void:
	if not body is Player:
		return
	if is_active:
		$CardAnimationPlayer.play("off")
		return
	$AnimationPlayer.play_backwards("off")
	$AnimationPlayer.queue("on")
	
