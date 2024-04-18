tool
extends Area2D

const TILES_BASE_SIZE := 8

export(LevelManager.Level) var go_to = LevelManager.Level.DEBUG_LEVEL_1
export(LevelTransition.Transition) var level_transition = LevelTransition.Transition.DOT
export var spawn_point := "none"
export(int, 1, 10) var tiles_x_multiplier := 1 setget set_tiles_x_multiplier
export(int, 1, 10) var tiles_y_multiplier := 4 setget set_tiles_y_multiplier


func set_tiles_x_multiplier(values: int) -> void:
	tiles_x_multiplier = values
	update_collision_shape() 


func set_tiles_y_multiplier(values: int) -> void:
	tiles_y_multiplier = values
	update_collision_shape()


func update_collision_shape() -> void:
	assert(has_node("CollisionShape2D"))
	$CollisionShape2D.shape.extents = Vector2(TILES_BASE_SIZE * tiles_x_multiplier, TILES_BASE_SIZE * tiles_y_multiplier) 
	$StaticBody2D/CollisionShape2D.shape.extents = Vector2(TILES_BASE_SIZE * tiles_x_multiplier - (TILES_BASE_SIZE/2), TILES_BASE_SIZE * tiles_y_multiplier - (TILES_BASE_SIZE/2)) 


func teleport(player: Player) -> void:
	GameManager.player_health = player.stats.health
	player.is_handling_input = false
	LevelManager.spawn_point = spawn_point
	LevelManager.last_look_direction_of_player = player.look_direction
	Events.emit_signal("scene_fadeout_transition_displayed", level_transition)
	LevelManager.current_level_id = go_to
