# Event bus pattern
# @see https://www.youtube.com/watch?v=S6PbC4Vqim4
# @see https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/event-bus/
extends Node

############
#### UI ####
############

# cinematic
signal cinematic_transition_started
signal cinematic_animation_finished
signal cinematic_transition_ended
signal cinematic_text_displayed(text)

# config
signal config_file_saved
signal config_file_loaded

#engine
signal engine_time_scale_changed(value)

# field
signal field_description_changed(description)
signal focused_row_changed(row)

# fieldset
signal fieldset_cleared(fieldset)
signal fieldset_inner_field_navigated(focused_field)

# gamepad binding
signal gamepad_listening_started
signal gamepad_layout_changed
signal gamepad_stick_layout_changed(joy_actions, translation_key)

# in-game interfaces
signal game_paused
signal game_unpaused
signal in_game_menu_hidden

# keybinding
signal key_listening_started(field, button, scancode)

# locale
signal locale_changed

# menu
signal menu_route_changed(route)
signal menu_transition_started(anim_name)
signal menu_transition_mid_animated
signal menu_transition_finished
signal menu_splashcreen_finished

# navigation
signal navigation_disabled
signal navigation_enabled

# overlay
signal overlay_displayed
signal overlay_hidden

# profile
signal erase_profile_dialog_displayed(for_profile, button)
signal erase_profile_dialog_confirm_button_pressed
signal new_profile_page_displayed(for_profile)
signal new_profile_created(profile)

# Required field unmapped
signal required_field_unmapped_displayed(unmapped_fields)

# save icon
signal save_notification_enabled

# user
signal user_has_changed_gamepad_bindind

############
#### Game ####
############

# ability
signal ability_unlocked(ability_type)

# beam
signal beam_selected(beam_type)
signal beam_unlocked(beam_type)

# boss
signal boss_defeated
signal boss_explosed

# card
signal card_unlocked(card_type)

# camera
signal camera_shake

# co-op
signal coop_player_removed(device_index)

# data
signal data_saved

# player
signal player_input_disabled
signal player_input_enabled
signal player_max_health_changed(value)
signal player_health_changed(value)
signal player_moved(player)
signal player_teleported_to(global_position)
signal player_state_changed_to(state, msg)
signal player_spawned

# popup
signal popup_displayed(text)
signal popup_closed
signal popup_coop_displayed(device_index)

# save
signal save_data_started
signal save_data_completed
signal saving_data_player_animation_finished

# saveroom
signal save_room_enabled

# transition
signal scene_fadeout_transition_displayed(type)
signal scene_fadein_transition_displayed(type)
signal scene_loading_started
signal scene_loaded
