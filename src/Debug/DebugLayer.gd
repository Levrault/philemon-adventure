extends CanvasLayer


func _ready() -> void:
	if not OS.has_feature("debug"):
		queue_free()
		return
	if not ProjectSettings.get_setting("game/show_fps"):
		$"%FPSCounter".queue_free()
