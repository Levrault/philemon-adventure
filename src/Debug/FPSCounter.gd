extends Label


func _process(delta: float) -> void:
	text = "%s" % Engine.get_frames_per_second()
