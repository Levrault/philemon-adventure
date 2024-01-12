extends HBoxContainer

onready var health_progress := $TextureProgress
onready var health_label := $Health

func _ready() -> void:
	yield(owner, "ready")
#	owner.stats.connect("health_changed", self, "_on_Health_changed")
#	health_progress.max_value = owner.stats.max_health
#	health_progress.value = owner.stats.health


func _on_Health_changed(new_value: float, old_value: float) -> void:
	health_label.text = "%s" % new_value
	health_progress.value = new_value
