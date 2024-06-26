# Load and save progression
extends Node

const ALLOW_DYNAMIC_VALUES = ["level_state"]
const PROFILE_TEMPLATE_PATH := "res://engine/profile_template.cfg"
const PROFILE_SLOTS := ["profile0", "profile1", "profile2"]
const SAVE_PATH := "user://%s.save"

var current_profile := "profile0"
var profiles := {}
var template := {}


func _ready() -> void:
	initialize()
	load_profiles()


# Create all profile slots
func initialize() -> void:
	var profile_template := ConfigFile.new()
	var err = profile_template.load(PROFILE_TEMPLATE_PATH)
	if err == ERR_FILE_NOT_FOUND:
		printerr("%s was not found" % [PROFILE_TEMPLATE_PATH])
		return
	if err != OK:
		printerr("%s has encounter an error: %s" % [PROFILE_TEMPLATE_PATH, err])
		return

	for section in profile_template.get_sections():
		template[section] = {}
		for key in profile_template.get_section_keys(section):
			template[section][key] = profile_template.get_value(section, key, null)

	for profile in PROFILE_SLOTS:
		var profile_file = File.new()
		if profile_file.file_exists(SAVE_PATH % profile):
			continue
		profile_file.open(SAVE_PATH % profile, File.WRITE)
		profile_file.store_line(to_json(template.duplicate(true)))
		profile_file.close()


func load_profiles() -> void:
	for profile in PROFILE_SLOTS:
		var profile_file = File.new()
		profile_file.open(SAVE_PATH % profile, File.READ)
		profiles[profile] = sync(
			profile, parse_json(profile_file.get_line()), template.duplicate(true)
		)
	print_debug("Profiles are loaded")


# sync current profile with profile_template
func sync(slot: String, profile: Dictionary, new_template: Dictionary) -> Dictionary:
	var has_changed := false
	# sync new data
	for section in new_template.keys():
		if not profile.has(section):
			profile[section] = {}

		for key in new_template[section].keys():
			if not profile[section].has(key):
				profile[section][key] = new_template[section][key]
				has_changed = true
				continue

			if typeof(new_template[section][key]) == TYPE_DICTIONARY:
				for inner_key in new_template[section][key].keys():
					if not profile[section][key].has(inner_key):
						profile[section][key][inner_key] = new_template[section][key][inner_key]
						has_changed = true
				continue

	# remove unused data
	for section in profile.keys():
		if not new_template.has(section):
			profile.erase(section)
			continue
		for key in profile[section].keys():
			if not new_template[section].has(key):
				profile[section].erase(key)
				has_changed = true
				continue

			if ALLOW_DYNAMIC_VALUES.has(key):
				continue

			if typeof(profile[section][key]) == TYPE_DICTIONARY:
				for inner_key in profile[section][key].keys():
					if not new_template[section][key].has(inner_key):
						profile[section][key].erase(inner_key)
						has_changed = true
				continue

	if has_changed:
		save_profile(slot, profile)
	return profile


func save_data() -> void:
	var data := get_current_profile()
	data.ability = GameManager.serialize_ability_status()
	data.beam = GameManager.serialize_beam_status()
	data.cards = GameManager.serialize_cards_status()
	data.progression.last_saveroom = LevelManager.serialize_last_saveroom()
	data.progression.last_saveroom_description = LevelManager.serialize_last_saveroom_description()
	data.progression.level_state = LevelManager.states
	save_profile(current_profile, get_current_profile())


func save_profile(profile_name: String, values: Dictionary) -> void:
	var profile_file := File.new()
	if not profile_file.file_exists(SAVE_PATH % profile_name):
		printerr("%s save file doesn't exist" % profile_name)
		return

	profile_file.open(SAVE_PATH % profile_name, File.WRITE)
	profile_file.store_line(to_json(values))
	profile_file.close()
	print_debug("%s has been saved" % profile_name)
	print_debug(values)


func erase_profile(profile_name: String) -> void:
	Directory.new().remove(SAVE_PATH % profile_name)

	var profile_file = File.new()
	profile_file.open(SAVE_PATH % profile_name, File.WRITE)
	profile_file.store_line(to_json(template.duplicate(true)))
	profile_file.close()
	profiles[profile_name] = template.duplicate(true)
	print_debug("%s save has been erased")


func get_current_profile() -> Dictionary:
	return profiles[current_profile]


func reload() -> void:
	var profile_file = File.new()
	profile_file.open(SAVE_PATH % current_profile, File.READ)
	profiles[current_profile] = sync(
		current_profile, parse_json(profile_file.get_line()), template.duplicate(true)
	)
