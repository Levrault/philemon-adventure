extends Node2D

var velocity := 200
var direction := 1

onready var sprite := $Sprite
onready var area := $Area2D
onready var animation_player := $AnimationPlayer


func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	area.connect("body_entered", self, "_on_Body_entered")


func _process(delta: float) -> void:
	position.x += (velocity * direction) * delta
	if direction == -1:
		sprite.flip_h = true


func _on_Body_entered(body) -> void:
	set_process(false)
	animation_player.play("feedback")
