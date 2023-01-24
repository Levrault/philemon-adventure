extends Node2D

const Feedback:PackedScene = preload("res://src/Projectiles/BeamFeedback.tscn")

var speed := 300.0
var direction := 1

onready var sprite := $Sprite
onready var area := $Area2D
onready var animation_player := $AnimationPlayer
onready var damage_source := $DamageSource


func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	$Fire.play()
	area.connect("body_entered", self, "_on_Body_entered")


func init(res: ProjectileResourceBase) -> void:
	speed = res.speed
	damage_source.damage = res.damage
	damage_source.is_instakill = res.is_instakill


func _process(delta: float) -> void:
	position.x += (speed * direction) * delta
	if direction == -1:
		sprite.flip_h = true


func _on_Body_entered(body: Node) -> void:
	var feedback := Feedback.instance()
	Global.add_child_to_root(feedback, global_position)
	print_debug("%s has hit %s" % [get_name(), body.get_name()])
	feedback.play_impact_sfx(body)
	call_deferred("queue_free")
