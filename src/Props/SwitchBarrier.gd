extends StaticBody2D


export(Array, NodePath) var targetObjectPath := []

onready var target_objects := []


func _ready():
	$Area2D.connect("body_entered", self, "_on_Body_entered")
	
	# find all targets
	for target_path in targetObjectPath:
		var target := get_node(target_path)
		if target != null:
			target_objects.append(target)
	
	
	var data = LevelManager.get_level_state(LevelManager.current_level_name)
	print(data)
	if data.has(get_name()):
		active_targets()


func active_targets() -> void:
	$AnimationPlayer.play("pushed")
	for target in target_objects:
		target.open({without_transition = false})
	$Area2D.queue_free()


func _on_Body_entered(body: Node) -> void:
	if not body is Player:
		return
	
	$AnimationPlayer.play("pushed")
	$AudioStreamPlayer.play()
	active_targets()
	LevelManager.update_level_state({
		get_name(): true
	})
