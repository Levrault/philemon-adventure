extends Node

signal scene_changed(path)

enum Level {
	MAIN_MENU,
	DEBUG_LEVEL_1,
	DEBUG_LEVEL_2,
	DEBUG_LEVEL_3,
	DEBUG_MULTIPLAYER,
	DEBUG_NAVIGATION_AGENT,
	DEBUG_SAVE_ROOM_1,
	ROOM_01,
	ROOM_02,
	ROOM_03,
	ROOM_04,
	ROOM_05,
	ROOM_06,
	ROOM_07,
	ROOM_08,
	ROOM_09,
	ROOM_10,
	ROOM_11,
	ROOM_12,
	ROOM_13,
	ROOM_14,
	ROOM_15,
	ROOM_16,
	ROOM_17,
	ROOM_18,
	ROOM_19,
	ROOM_20,
	ROOM_21,
	INTRO,
	ENDING,
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
		Level.INTRO:
			return "res://src/World/Room/Intro.tscn"
		Level.ROOM_01:
			return "res://src/World/Room/Room01.tscn"
		Level.ROOM_02:
			return "res://src/World/Room/Room02.tscn"
		Level.ROOM_03:
			return "res://src/World/Room/Room03.tscn"
		Level.ROOM_04:
			return "res://src/World/Room/Room04.tscn"
		Level.ROOM_05:
			return "res://src/World/Room/Room05.tscn"
		Level.ROOM_06:
			return "res://src/World/Room/Room06.tscn"
		Level.ROOM_07:
			return "res://src/World/Room/Room07.tscn"
		Level.ROOM_08:
			return "res://src/World/Room/Room08.tscn"
		Level.ROOM_09:
			return "res://src/World/Room/Room09.tscn"
		Level.ROOM_10:
			return "res://src/World/Room/Room10.tscn"
		Level.ROOM_11:
			return "res://src/World/Room/Room11.tscn"
		Level.ROOM_12:
			return "res://src/World/Room/Room12.tscn"
		Level.ROOM_13:
			return "res://src/World/Room/Room13.tscn"
		Level.ROOM_14:
			return "res://src/World/Room/Room14.tscn"
		Level.ROOM_15:
			return "res://src/World/Room/Room15.tscn"
		Level.ROOM_16:
			return "res://src/World/Room/Room16.tscn"
		Level.ROOM_17:
			return "res://src/World/Room/Room17.tscn"
		Level.ROOM_18:
			return "res://src/World/Room/Room18.tscn"
		Level.ROOM_19:
			return "res://src/World/Room/Room19.tscn"
		Level.ROOM_20:
			return "res://src/World/Room/Room20.tscn"
		Level.ROOM_21:
			return "res://src/World/Room/Room21.tscn"
		Level.ENDING:
			return "res://src/World/Room/Ending.tscn"
		Level.DEBUG_LEVEL_1:
			return "res://src/World/Debug/DebugLevel1.tscn"
		Level.DEBUG_LEVEL_2:
			return "res://src/World/Debug/DebugLevel2.tscn"
		Level.DEBUG_LEVEL_3:
			return "res://src/World/Debug/DebugLevel3.tscn"
		Level.DEBUG_MULTIPLAYER:
			return "res://src/World/Debug/DebugMultiplayer.tscn"
		Level.DEBUG_NAVIGATION_AGENT:
			return "res://src/World/Debug/DebugNavigationAgent.tscn"
		Level.DEBUG_SAVE_ROOM_1:
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
	var data = states.get(level_name)
	if data:
		return data
	return {}


func serialize_last_saveroom() -> String:
	return current_level_name


func serialize_level_state() -> Dictionary:
	return states
