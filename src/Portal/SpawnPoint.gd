tool
extends Position2D



func _ready() -> void:
	if OS.has_feature("debug"):
		connect("renamed", self, "_on_Renamed")
		return
	
	$Label.queue_free()
	$Sprite.queue_free()


func _on_Renamed() -> void:
	$Label.text = get_name()
