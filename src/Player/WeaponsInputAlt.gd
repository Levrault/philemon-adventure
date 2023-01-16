extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_pressed("hyperbeam") and GameManager.is_beam_upgrade_status_unlocked(GameManager.BeamType.HYPERBEAM):
		owner.current_beam_type = GameManager.BeamType.HYPERBEAM
		return
	if Input.is_action_pressed("curvedbeam") and GameManager.is_beam_upgrade_status_unlocked(GameManager.BeamType.CURVED_BEAM):
		owner.current_beam_type = GameManager.BeamType.CURVED_BEAM
		return
	owner.current_beam_type = GameManager.BeamType.BEAM
