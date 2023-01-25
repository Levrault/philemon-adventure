# Enable to navigate between all the differents menu ui
# by setting up which menu needs to be show (based on node name)
# @category: Navigation
extends NavigationButton


# Only navigate to Worldmap, doesn't update
# history since the player shouldn't be able
# to go back to create profile back when clicking PreviousPage button
func _on_Pressed() -> void:
	owner.form.save()
	Events.emit_signal("new_profile_created", owner.form.profile)
	Serialize.current_profile = owner.form.profile
	owner.form.reset()
	
	Events.emit_signal("scene_fadeout_transition_displayed", LevelTransition.Transition.WINDOW_BLIND_DIAGONAL)
	LevelManager.current_level_id = LevelManager.Level.keys().find(Serialize.get_current_profile().progression.last_saveroom)
	print_debug("%s - %s has been set has current profile" % [Serialize.current_profile, owner.form.profile_name])
