extends Node

enum PlayerStatus {
	alive,
	spawing,
	death
}

enum BeamType {
	BEAM, HYPERBEAM, CURVED_BEAM
}

enum Ability {
	JUMP,
	DOUBLE_JUMP
}

enum Card {
	LVL_1,
	LVL_2,
	LVL_3,
	LVL_4
}

const LAYER = {
	"WORLD": 0,
	"PLAYER": 1,
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
	Ability.keys()[Ability.JUMP]: false,
	Ability.keys()[Ability.DOUBLE_JUMP]: false,
}

var card_upgrades_status = {
	Card.keys()[Card.LVL_1]: false,
	Card.keys()[Card.LVL_2]: false,
	Card.keys()[Card.LVL_3]: false,
	Card.keys()[Card.LVL_4]: false,
}

var player_health := 99
var beam_keys := BeamType.keys()
var ability_keys := Ability.keys()
var card_keys := Card.keys()
var player_status: int = PlayerStatus.alive


func _ready() -> void:
	if OS.has_feature("debug"):
		if ProjectSettings.get_setting("game/beam_unlocked"):
			unlock_beam(BeamType.BEAM)
		if ProjectSettings.get_setting("game/hyperbeam_unlocked"):
			unlock_beam(BeamType.HYPERBEAM)
		if ProjectSettings.get_setting("game/curvedbeam_unlocked"):
			unlock_beam(BeamType.CURVED_BEAM)
		if ProjectSettings.get_setting("game/jump_unlocked"):
			unlock_ability(Ability.JUMP)
		if ProjectSettings.get_setting("game/double_jump_unlocked"):
			unlock_ability(Ability.DOUBLE_JUMP)
		if ProjectSettings.get_setting("game/card_lvl_1_unlocked"):
			unlock_card(Card.LVL_1)
		if ProjectSettings.get_setting("game/card_lvl_2_unlocked"):
			unlock_card(Card.LVL_2)
		if ProjectSettings.get_setting("game/card_lvl_3_unlocked"):
			unlock_card(Card.LVL_3)
		if ProjectSettings.get_setting("game/card_lvl_4_unlocked"):
			unlock_card(Card.LVL_4)


func unlock_progression() -> void:
	print("-- Player unlock progression --")
	var data = Serialize.get_current_profile()
	if data.ability.jump:
		print("Player has unlocked jump ability")
		ability_upgrades_status[ability_keys[Ability.JUMP]] = true
	if data.beam.beam:
		print("Player has unlocked beam")
		beam_upgrades_status[beam_keys[BeamType.BEAM]] = true
	if data.beam.hyperbeam:
		print("Player has unlocked hyperbeam")
		beam_upgrades_status[beam_keys[BeamType.HYPERBEAM]] = true
	if data.cards.lvl_1:
		print("Player has unlocked card lvl_1")
		card_upgrades_status[card_keys[Card.LVL_1]] = true
	if data.cards.lvl_2:
		print("Player has unlocked card lvl_2")
		card_upgrades_status[card_keys[Card.LVL_2]] = true
	if data.cards.lvl_3:
		print("Player has unlocked card lvl_3")
		card_upgrades_status[card_keys[Card.LVL_3]] = true
	if data.cards.lvl_4:
		print("Player has unlocked card lvl_4")
		card_upgrades_status[card_keys[Card.LVL_4]] = true


func is_beam_upgrade_status_unlocked(beam_type: int) -> bool:
	return beam_upgrades_status[beam_keys[beam_type]]


func is_ability_upgrade_status_unlocked(ability_type: int) -> bool:
	return ability_upgrades_status[ability_keys[ability_type]]


func is_card_upgrade_status_unlocked(card_type: int) -> bool:
	return card_upgrades_status[card_keys[card_type]]


func unlock_beam(beam_type: int) -> void:
	print_debug("Beam %s has been unlocked" % beam_keys[beam_type])
	beam_upgrades_status[beam_keys[beam_type]] = true
	Events.emit_signal("beam_unlocked", beam_type)


func unlock_ability(ability_type: int) -> void:
	print_debug("Ability %s has been unlocked" % ability_keys[ability_type])
	ability_upgrades_status[ability_keys[ability_type]] = true
	Events.emit_signal("ability_unlocked", ability_type)


func unlock_card(card_type: int) -> void:
	print_debug("Card %s has been unlocked" % card_keys[card_type])
	card_upgrades_status[card_keys[card_type]] = true
	Events.emit_signal("card_unlocked", card_type)


func player_died() -> void:
	player_status = PlayerStatus.death
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.THEATRAL)
	LevelManager.current_level_id = LevelManager.Level.GAME_OVER


func serialize_ability_status() -> Dictionary:
	var data := {}
	for value in ability_keys:
		data[value.to_lower()] = ability_upgrades_status[value]
	return data


func serialize_beam_status() -> Dictionary:
	var data := {}
	for value in beam_keys:
		data[value.to_lower()] = beam_upgrades_status[value]
	return data


func serialize_cards_status() -> Dictionary:
	var data := {}
	for value in card_keys:
		data[value.to_lower()] = card_upgrades_status[value]
	return data
