extends Node

const LAYER = {
	"WORLD": 0,
	"MOVING_PLATFORM" : 3,
	"DAMAGE_SOURCE_LAYER" : 4,
	"LADDER_ONE_WAY_PLATFORM_LAYER" : 5
}


func add_child_to_root(instance: Node, global_position: Vector2) -> void:
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
