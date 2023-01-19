extends HBoxContainer

const TRANSPARENCY := .5

onready var beam := $Beam
onready var curvedbeam := $CurvedBeam


func _ready() -> void:
	Events.connect("beam_selected", self, "_on_Beam_selected")
	Events.connect("beam_unlocked", self, "_on_Beam_unlocked")
	
	var has_one_beam_unlocked := false
	for child in get_children():
		if GameManager.is_beam_upgrade_status_unlocked(child.id):
			child.modulate.a = TRANSPARENCY
			has_one_beam_unlocked = true
			continue
		child.modulate.a = 0.0

	if has_one_beam_unlocked:
		_on_Beam_selected(GameManager.BeamType.BEAM)


func _on_Beam_selected(beam_type: int) -> void:
	for child in get_children():
		if child.id == beam_type:
			child.modulate.a = 1.0
			continue
		if GameManager.is_beam_upgrade_status_unlocked(child.id):
			child.modulate.a = TRANSPARENCY
			continue
		child.modulate.a = 0.0


func _on_Beam_unlocked(beam_type: int) -> void:
	for child in get_children():
		if child.id == beam_type:
			child.modulate.a = TRANSPARENCY
			continue
	# default callback
	_on_Beam_selected(GameManager.BeamType.BEAM)
