# Load a profile
# @category: Button
extends GenericButton

onready var profile_name := $MarginContainer/VBoxContainer/Row1/ProfileName
onready var level := $MarginContainer/VBoxContainer/Row1/Level


func set_data(data: Dictionary) -> void:
	profile_name.text = data.profile.name
	
	if data.progression.last_saveroom_description.empty():
		level.text = tr("profile.new_adventure")
	else:
		level.text = tr(data.progression.last_saveroom_description)
	

func _on_Pressed() -> void:
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.WINDOW_BLIND_DIAGONAL)
	Serialize.current_profile = Serialize.PROFILE_SLOTS[owner.get_index()]
	LevelManager.states = Serialize.get_current_profile().progression.level_state
	if Serialize.get_current_profile().progression.last_saveroom == "INTRO":
		GameManager.player_status = GameManager.PlayerStatus.alive
	else:
		GameManager.player_status = GameManager.PlayerStatus.spawing
	GameManager.unlock_progression()
	LevelManager.current_level_id = LevelManager.Level.keys().find(Serialize.get_current_profile().progression.last_saveroom)
	print_debug("%s - %s has been set has current profile" % [Serialize.current_profile, profile_name.text])
