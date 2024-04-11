extends Area2D

const EXPLOSION = preload("res://src/VFX/ExplosionDamage.tscn")

var explosions := []
var index = 0

onready var timer = $Timer


func _ready() -> void:
	yield(owner, "ready")
	connect("body_entered", self, "_on_Body_entered")
	timer.wait_time = .05
	timer.connect("timeout", self, "_on_Timeout")
	explosions = get_parent().get_node("Explosions").get_children()
	
	
func _on_Body_entered(body: Node) -> void:
	if not body is Boss:
		return
	timer.start()


func _on_Timeout() -> void:
	if index >= explosions.size():
		timer.stop()
		index = 0
		return
	explosions[index].add_child(EXPLOSION.instance())
	index += 1
