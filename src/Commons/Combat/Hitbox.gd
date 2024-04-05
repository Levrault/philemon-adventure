class_name Hitbox
extends Area2D

export (String) var collider_name := "CollisionShape2D" setget set_collider_name
onready var collider: CollisionShape2D = get_node_or_null(collider_name)

var is_active := true setget set_is_active
var timer: Timer
var looping_damage_source: DamageSource = null


func _ready() -> void:
	if collider == null:
		queue_free()
	connect("area_entered", self, "_on_Area_entered")
	connect("area_exited", self, "_on_Area_exited")


func set_is_active(value: bool) -> void:
	is_active = value
	collider.set_deferred("disabled", not value)


func set_collider_name(node_name: String) -> void:
	if has_node(collider_name):
		get_node(collider_name).disabled = true
	if has_node(node_name):
		get_node(node_name).disabled = false

	print_debug("player hitbox %s changed to %s" % [collider_name, node_name])
	collider_name = node_name


func _on_Area_entered(damage_source: Area2D) -> void:
	if owner is Shield:
		damage_source.owner.destroy(owner)
		if damage_source.owner.type != GameManager.BeamType.HYPERBEAM:
			return
	if "hit_direction" in owner:
		var direction = -1 if damage_source.global_position.x > global_position.x else 1
		owner.hit_direction = direction
	if damage_source.looping_damage:
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", self, "_on_Timeout")
		timer.wait_time = .55 # hack since invulnerable time is .5
		timer.start()
		looping_damage_source = damage_source
	if not owner.stats.invulnerable or damage_source.is_instakill:
		owner.take_damage(Hit.new(damage_source))


func _on_Area_exited(damage_source: Area2D) -> void:
	if damage_source == looping_damage_source:
		looping_damage_source = null
		timer.stop()
		timer.queue_free()


func _on_Timeout() -> void:
	print("Timeout")
	if not looping_damage_source:
		return
	owner.take_damage(Hit.new(looping_damage_source))
	
