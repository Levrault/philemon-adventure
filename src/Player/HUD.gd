extends CanvasLayer


func _ready():
	Events.connect("cinematic_transition_started", self, "hide")
	Events.connect("cinematic_ending_transition_started", self, "hide")
	Events.connect("cinematic_transition_ended", self, "show")

