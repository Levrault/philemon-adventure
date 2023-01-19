# Load a profile
# @category: Button
extends GenericButton

onready var profile_name := $MarginContainer/VBoxContainer/Row1/ProfileName
onready var level := $MarginContainer/VBoxContainer/Row1/Level
onready var playtime := $MarginContainer/VBoxContainer/Row2/Playtime
onready var completed := $MarginContainer/VBoxContainer/Row2/Completed


func set_data(data: Dictionary) -> void:
	profile_name.text = data.profile.name
	playtime.text = tr("profile.playtime").format({time = playtime.seconds2hhmmss(data.stats.total_play_time)})
	completed.text = tr("profile.completed").format({percentage = completed.format_completed(data)})


func _on_Pressed() -> void:
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.WINDOW_BLIND_DIAGONAL)
	Serialize.current_profile = Serialize.PROFILE_SLOTS[owner.get_index()]
	LevelManager.next_scene = LevelManager.Level.keys().find(Serialize.get_current_profile().progression.last_saveroom)
	print_debug("%s - %s has been set has current profile" % [Serialize.current_profile, profile_name.text])
