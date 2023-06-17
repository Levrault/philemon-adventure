extends Area2D


func _ready() -> void:
	connect("area_entered", self, "_on_Area_entered")


func _on_Area_entered(area: Area2D) -> void:
	area.teleport(owner)

