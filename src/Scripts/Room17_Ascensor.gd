extends Node2D

export(Array, NodePath) var platforms := []

onready var area_spawn_top = $AreaSpawnTop
onready var area_spawn_bottom = $AreaSpawnBottom
onready var area_top = $AreaTop
onready var area_bottom = $AreaBottom
onready var camera = $"../../Camera"


func _ready():
	area_spawn_top.connect("body_entered", self, "_on_Area_spawn_top_entered")
	area_spawn_bottom.connect("body_entered", self, "_on_Area_spawn_bottom_entered")


func _on_Area_spawn_top_entered(body: Node) -> void:
	if not body is Player:
		return
	area_top.connect("body_entered", self, "_on_Area_top_body_entered")
	area_spawn_top.set_deferred("monitoring", false)
	area_spawn_bottom.set_deferred("monitoring", false)


func _on_Area_spawn_bottom_entered(body: Node) -> void:
	print("_on_Area_spawn_bottom_entered")
	if not body is Player:
		return
	area_bottom.connect("body_entered", self, "_on_Area_bottom_body_entered")
	for platform in platforms:
		get_node(platform).position = get_node(platform).get_parent().points[1]
	area_spawn_top.set_deferred("monitoring", false)
	area_spawn_bottom.set_deferred("monitoring", false)


func _on_Area_top_body_entered(body: Node) -> void:
	if not body is Player:
		return
	body.is_handling_input = false
	area_bottom.connect("body_entered", self, "_on_Area_bottom_stop_body_entered")
	Events.connect("cinematic_animation_finished", self, "_on_Ascensor_started")
	Events.emit_signal("cinematic_transition_started")
	area_top.disconnect("body_entered", self, "_on_Area_top_body_entered")


func _on_Area_bottom_body_entered(body: Node) -> void:
	if not body is Player:
		return
	body.is_handling_input = false
	area_top.connect("body_entered", self, "_on_Area_top_stop_body_entered")
	Events.connect("cinematic_animation_finished", self, "_on_Ascensor_started")
	Events.emit_signal("cinematic_transition_started")
	area_bottom.disconnect("body_entered", self, "_on_Area_bottom_body_entered")


func _on_Area_bottom_stop_body_entered(body: Node) -> void:
	if not body is Player:
		return
	Events.connect("cinematic_animation_finished", self, "_on_Ascensor_stopped")
	Events.emit_signal("cinematic_transition_ended")
	body.is_handling_input = true
	area_bottom.disconnect("body_entered", self, "_on_Area_bottom_stop_body_entered")
	area_spawn_bottom.set_deferred("monitoring", true)


func _on_Area_top_stop_body_entered(body: Node) -> void:
	if not body is Player:
		return
	Events.connect("cinematic_animation_finished", self, "_on_Ascensor_stopped")
	Events.emit_signal("cinematic_transition_ended")
	body.is_handling_input = true
	area_top.disconnect("body_entered", self, "_on_Area_top_stop_body_entered")
	area_spawn_top.set_deferred("monitoring", true)


func _on_Ascensor_started() -> void:
	Events.disconnect("cinematic_animation_finished", self, "_on_Ascensor_started")
	for platform in platforms:
		get_node(platform).timer.start()


func _on_Ascensor_stopped() -> void:
	Events.disconnect("cinematic_animation_finished", self, "_on_Ascensor_stopped")
	for platform in platforms:
		get_node(platform).timer.stop()
