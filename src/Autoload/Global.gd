extends Node


func add_child_to_root(instance: Node, global_position: Vector2) -> void:
	LevelManager.current_scene_node.add_child(instance)
	instance.global_position = global_position
