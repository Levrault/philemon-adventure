extends Area2D
class_name AbilityUpgrade

var PickFeedback := preload("res://src/VFX/PickFeedbackCircle.tscn")

export(GameManager.Ability) var type := GameManager.Ability.DOUBLE_JUMP


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	if GameManager.is_ability_upgrade_status_unlocked(type):
		queue_free()


func _on_Body_entered(body: Node) -> void:
	assert(body is Player)
	print_debug("Player has picked the %s" % get_name())
	
	GameManager.unlock_ability(type)
	GameManager.add_child_to_root(PickFeedback.instance(), global_position)
	call_deferred("queue_free")
