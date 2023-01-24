class_name BeamUpgrade
extends Area2D

var PickFeedback := preload("res://src/VFX/PickFeedbackCircle.tscn")

export(GameManager.BeamType) var type := GameManager.BeamType.BEAM


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	
	if GameManager.is_beam_upgrade_status_unlocked(type):
		queue_free()


func _on_Body_entered(body: Node) -> void:
	assert(body is Player)
	print_debug("Player has picked the %s" % get_name())
	GameManager.unlock_beam(type)
	Global.add_child_to_root(PickFeedback.instance(), global_position)
	call_deferred("queue_free")
