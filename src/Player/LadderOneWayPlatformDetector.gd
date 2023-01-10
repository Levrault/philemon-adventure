extends Area2D


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")


func _on_Body_entered(body: Node) -> void:
	if body is Player:
		return
	owner.flag.ladder_one_way_platform = true


func _on_Body_exited(body: Node) -> void:
	owner.flag.ladder_one_way_platform = false
