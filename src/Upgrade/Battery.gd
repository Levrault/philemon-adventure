extends Node2D

const PICK_FEEDBACK = preload("res://src/VFX/PickFeedbackCircle.tscn")

onready var area = $Area2D


func _ready():
	area.connect("body_entered", self, "_on_Body_entered")


func _on_Body_entered(body: Node) -> void:
	if not body is Player:
		return
	body.stats.heal(10)
	Global.call_deferred("add_child_to_root", PICK_FEEDBACK.instance(), global_position)
	call_deferred("queue_free")
