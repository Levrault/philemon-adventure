extends CanvasLayer



func _ready():
	hide()
	Events.connect("crt_enabled", self, "show")
	Events.connect("crt_disabled", self, "hide")
