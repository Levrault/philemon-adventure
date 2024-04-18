extends Node2D

const PICK_FEEDBACK = preload("res://src/VFX/PickFeedbackCircleWithAudio.tscn")

var size := 0
onready var area = $Area2D


func _ready():
	area.connect("body_entered", self, "_on_Body_entered")
	size = randi() % 6
	if size == 0:
		scale = Vector2(.5, .5)
	elif size == 1:
		scale = Vector2(.75, .75)
	elif size == 2:
		scale = Vector2(1, 1)
	else:
		queue_free()


func _on_Body_entered(body: Node) -> void:
	if not body is Player:
		return
	if size == 0:
		body.stats.heal(5)
	elif size == 1:
		body.stats.heal(10)
	elif size == 2:
		body.stats.heal(15)
	Global.call_deferred("add_child_to_root", PICK_FEEDBACK.instance(), global_position)
	call_deferred("queue_free")
	body.skin.hit_flash()
