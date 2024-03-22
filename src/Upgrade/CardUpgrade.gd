tool
class_name CardUpgrade
extends Area2D

var PickFeedback := preload("res://src/VFX/PickFeedbackCircle.tscn")

export(GameManager.Card) var type := GameManager.Card.LVL_1 setget set_type


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	if GameManager.is_card_upgrade_status_unlocked(type):
		queue_free()


func set_type(p_type: int) -> void:
	type = p_type
	if type == GameManager.Card.LVL_1:
		$Sprite.frame = 1
		return
	if type == GameManager.Card.LVL_2:
		$Sprite.frame = 3
		return
	if type == GameManager.Card.LVL_3:
		$Sprite.frame = 2
		return
	if type == GameManager.Card.LVL_4:
		$Sprite.frame = 0
		return


func _on_Body_entered(body: Node) -> void:
	assert(body is Player)
	print_debug("Player has picked the %s" % get_name())
	
	GameManager.unlock_card(type)
	Global.add_child_to_root(PickFeedback.instance(), global_position)
	call_deferred("queue_free")
