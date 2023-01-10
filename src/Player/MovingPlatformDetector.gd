extends Area2D


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")


func _on_Body_entered(body: Node) -> void:
	owner.flag.moving_platform = true


func _on_Body_exited(body: Node) -> void:
	owner.flag.moving_platform = false
