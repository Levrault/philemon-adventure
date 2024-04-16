extends State


onready var timer := $Timer


func unhandled_input(event: InputEvent) -> void:
	if not owner.is_on_floor():
		return
		
	if owner.state_machine.state_name == "Climbing":
		return
	
	if event.is_action_pressed(owner.actions.fire):
		owner.muzzle.shoot(owner.get_firing_beam_resource())
		
		if owner.has_charged_beam(owner.current_beam_type):
			var charged_resource = owner.get_charged_beam_resource()
			if GameManager.is_beam_upgrade_status_unlocked(charged_resource.id):
				timer.start()
			return
	if event.is_action_released(owner.actions.fire):
		timer.stop()
		return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	timer.connect("timeout", self, "_on_Timeout")
	if not GameManager.is_beam_upgrade_status_unlocked(owner.get_firing_beam_resource().id):
		_state_machine.transition_to("Cancel")
		return
	
	if "firing" in msg:
		owner.muzzle.shoot(owner.get_firing_beam_resource())
		if owner.has_charged_beam(owner.current_beam_type):
			var charged_resource = owner.get_charged_beam_resource()
			if GameManager.is_beam_upgrade_status_unlocked(charged_resource.id):
				timer.start()
			return


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout")
	timer.stop()


func _on_Timeout() -> void:
	_state_machine.transition_to("Charging")
