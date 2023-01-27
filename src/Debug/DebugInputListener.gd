extends Node

var player: Player = null


func _ready() -> void:
	yield(owner, "ready")
	player = owner.player


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("debug_die"):
		var damage_source := DamageSource.new()
		damage_source.is_instakill = true
		player.take_damage(Hit.new(damage_source))
		return
	
	if event.is_action_pressed("debug_free_camera"):
		player.is_handling_input = not player.is_handling_input
		if not player.is_handling_input:
			owner.get_node("Camera").current = false
			var free_camera: Camera2D = load("res://src/Debug/FreeCamera.tscn").instance()
			free_camera.position = player.position
			add_child(free_camera)
		else:
			owner.get_node("Camera").current = true
			get_node("FreeCamera").queue_free()

	if event.is_action_pressed("debug_camera_shake"):
		owner.get_node("Camera").is_shaking = true
