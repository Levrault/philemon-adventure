extends Area2D


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")


func _on_Body_entered(body: Node) -> void:
	body.owner.active_save_station()


func _on_Body_exited(body: Node) -> void:
	body.owner.inactive_save_station()
