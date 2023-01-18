extends Node

signal scene_changed(path)

enum Level {
	DEBUG_LEVEL_1,
	DEBUG_LEVEL_2,
	DEBUG_LEVEL_3
}

var spawn_point := ""
var next_scene = Level.DEBUG_LEVEL_1
var last_look_direction_of_player := 0

onready var current_scene_node: Node = get_tree().get_root()


func change_for_next_scene() -> void:
	change_scene_for(next_scene)


func change_scene_for(level: int) -> void:
	print_debug("Level %s will be loaded" % get_level_path(level))
	emit_signal("scene_changed", get_level_path(level))


func get_level_path(level: int) -> String:
	match level:
		Level.DEBUG_LEVEL_1:
			return "res://src/World/Debug/DebugLevel1.tscn"
		Level.DEBUG_LEVEL_2:
			return "res://src/World/Debug/DebugLevel2.tscn"
		Level.DEBUG_LEVEL_3:
			return "res://src/World/Debug/DebugLevel3.tscn"
		_:
			printerr("Level %s doesn't exist" % level)
			return ""
