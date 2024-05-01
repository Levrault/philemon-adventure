extends Updater


func _ready():
	yield(owner,"ready")
	get_parent().checkbox.connect("toggled", self, "_on_toggled")


func apply(properties: Dictionary, trigger_callback_action := true) -> void:
	if properties.get("enabled", false):
		GameManager.friendly_fire = true
	else:
		GameManager.friendly_fire = false


func _on_toggled(button_pressed: bool) -> void:
	GameManager.friendly_fire = button_pressed
