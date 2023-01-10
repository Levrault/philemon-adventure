tool
extends Area2D
class_name Ladder

const TYLES_Y_BASE_SIZE := 8
const BORDER_SIZE := 2

export(int, 1, 10) var tiles_y_multiplier := 1 setget set_tiles_y_multiplier


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")


func set_tiles_y_multiplier(value: int) -> void:
	tiles_y_multiplier = value
	$CollisionShape2D.shape.extents = Vector2($CollisionShape2D.shape.extents.x, (TYLES_Y_BASE_SIZE * tiles_y_multiplier) + BORDER_SIZE) 
	$Platform.position.y = ((TYLES_Y_BASE_SIZE * tiles_y_multiplier) - BORDER_SIZE) * -1


func _on_Body_entered(body: Node) -> void:
	body.flag.ladder = true
	body.ladder_position = global_position


func _on_Body_exited(body: Node) -> void:
	body.flag.ladder = false
