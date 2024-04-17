extends CanvasLayer


func _ready():
	if not OS.has_feature("debug"):
		queue_free()

