extends Node

enum BeamType {
	BEAM, HYPERBEAM, CURVED_BEAM
}

enum Ability {
	DOUBLE_JUMP
}

const LAYER = {
	"WORLD": 0,
	"MOVING_PLATFORM" : 3,
	"DAMAGE_SOURCE_LAYER" : 4,
	"LADDER_ONE_WAY_PLATFORM_LAYER" : 5
}

var beam_upgrades_status = {
	BeamType.keys()[BeamType.BEAM]: false,
	BeamType.keys()[BeamType.HYPERBEAM]: false,
	BeamType.keys()[BeamType.CURVED_BEAM]: false,
}

var ability_upgrades_status = {
	Ability.keys()[Ability.DOUBLE_JUMP]: false,
}

var beam_keys := BeamType.keys()
var ability_keys := Ability.keys()


func add_child_to_root(instance: Node, global_position: Vector2) -> void:
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position


func is_beam_upgrade_status_unlocked(beam_type: int) -> bool:
	return beam_upgrades_status[beam_keys[beam_type]]


func is_ability_upgrade_status_unlocked(ability_type: int) -> bool:
	return ability_upgrades_status[ability_keys[ability_type]]


func pause_game() -> void:
	get_tree().paused = true


func unpause_game() -> void:
	get_tree().paused = false


func unlock_beam(beam_type: int) -> void:
	print_debug("Beam %s has been unlocked" % beam_keys[beam_type])
	beam_upgrades_status[beam_keys[beam_type]] = true
	Events.emit_signal("beam_unlocked", beam_type)


func unlock_ability(ability_type: int) -> void:
	print_debug("Ability %s has been unlocked" % ability_keys[ability_type])
	ability_upgrades_status[ability_keys[ability_type]] = true
	Events.emit_signal("ability_unlocked", ability_type)
