extends Node

signal scene_changed(path)

enum Level {
	MAIN_MENU,
	DEBUG_LEVEL_1,
	DEBUG_LEVEL_2,
	DEBUG_LEVEL_3,
	DEBUG_NAVIGATION_AGENT,
	SAVE_ROOM_1
}

var level_keys := Level.keys()
var spawn_point := ""
var current_level_id = Level.DEBUG_LEVEL_1 setget set_current_level_id
var current_level_name = level_keys[current_level_id]
var last_look_direction_of_player := 0

onready var current_scene_node: Node = get_tree().get_root()
onready var states:Dictionary = Serialize.get_current_profile().progression.level_state


func set_current_level_id(value: int) -> void:
	current_level_id = value
	current_level_name = level_keys[current_level_id]


func change_for_next_scene() -> void:
	change_scene_for(current_level_id)


func change_scene_for(level: int) -> void:
	print_debug("Level %s will be loaded" % get_level_path(level))
	emit_signal("scene_changed", get_level_path(level))


func get_level_path(level: int) -> String:
	match level:
		Level.MAIN_MENU:
			return "res://src/UI/MainMenu.tscn"
		Level.DEBUG_LEVEL_1:
			return "res://src/World/Debug/DebugLevel1.tscn"
		Level.DEBUG_LEVEL_2:
			return "res://src/World/Debug/DebugLevel2.tscn"
		Level.DEBUG_LEVEL_3:
			return "res://src/World/Debug/DebugLevel3.tscn"
		Level.DEBUG_NAVIGATION_AGENT:
			return "res://src/World/Debug/DebugNavigationAgent.tscn"
		Level.SAVE_ROOM_1:
			return "res://src/World/SaveRoom/SaveRoom1.tscn"
		_:
			printerr("Level %s doesn't exist" % level)
			return ""


func update_level_state(new_data) -> void:
	var level_key = current_level_name
	if states.get(level_key) == null:
		states[level_key] = {}
	states[level_key] = new_data
	print_debug("LevelManager: %s has been stocked inside states" % new_data)


func get_level_state(level_name) -> Dictionary:
	print(states)
	var data = states.get(level_name)
	if data:
		return data
	return {}


func serialize_last_saveroom() -> String:
	return current_level_name


func serialize_level_state() -> Dictionary:
	return states
