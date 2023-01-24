# Singleton that manage level
extends Node

export(LevelManager.Level) var current_level = LevelManager.Level.DEBUG_LEVEL_1

var loader: ResourceInteractiveLoader = null
var wait_frames: int = 1
var time_max: int = 100
var current_scene = null


func _ready() -> void:
	yield(owner, "ready")
	LevelManager.connect("scene_changed", self, "goto_scene")
	pause_mode = PAUSE_MODE_PROCESS
	
	if get_children().empty():

		if current_level != LevelManager.Level.MAIN_MENU:
			Events.emit_signal("scene_fadein_transition_displayed")
			yield(get_tree().create_timer(.5), "timeout")
		goto_scene(LevelManager.get_level_path(current_level))
		return
	current_scene = get_child(0)


# Catch when a level can't be found
func show_error() -> void:
	printerr("Scene was not loaded")


# load new scene
# @param {String} path
func goto_scene(path: String) -> void:  
	print_debug("Loading %s" % path)
	loader = ResourceLoader.load_interactive(path)
	if loader == null:  
		show_error()
		return

	pause_mode = PAUSE_MODE_PROCESS
	set_process(true)
	if current_scene:
		current_scene.queue_free()
	wait_frames = 1


# compute loading process
# @param {float} time
func _process(time: float) -> void:
	if loader == null:
		set_process(false)
		return

	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()

		if err == ERR_FILE_EOF:  
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			break
		else:
			show_error()
			loader = null
			break


# load new scene
# @param {Resource} scene_resource
func set_new_scene(scene_resource: Resource) -> void:
	Events.emit_signal("scene_loaded")
	current_scene = scene_resource.instance()
	LevelManager.current_scene_node = current_scene
	add_child(current_scene)
	set_process(false)
	pause_mode = PAUSE_MODE_STOP
