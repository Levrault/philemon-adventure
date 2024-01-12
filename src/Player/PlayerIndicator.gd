extends Label


func _ready():
	text = "P%s" % (owner.device_index + 1)
