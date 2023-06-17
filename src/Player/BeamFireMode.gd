class_name BeamFireMode, "res://editor/icons/attack_factory.svg"
extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(owner.actions.fire_mode):
		next_beam_type()


func next_beam_type() -> void:
	var next_beam_type = owner.get_next_beam(owner.current_beam_type)
	if not GameManager.is_beam_upgrade_status_unlocked(next_beam_type):
		return
	owner.current_beam_type = next_beam_type
	print_debug("Player has changed firemode for %s" % GameManager.beam_keys[next_beam_type])

