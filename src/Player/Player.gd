extends Actor
class_name Player

enum CollisionType {
	STANDING, DUCKING
}

const FLOOR_NORMAL := Vector2.UP
const SNAP := Vector2(0, 10)

var is_active := true setget set_is_active
var is_handling_input := true setget set_is_handling_input
var is_on_moving_platform := false
var initial_state_data := {}
var life := 3
var spawn_position := position
var ladder_position := Vector2.ZERO
var flag := {
	"ladder": false,
	"ladder_one_way_platform": false,
	"moving_platform": false
}

onready var state_machine: StateMachine = $StateMachine
onready var collider: CollisionShape2D = $CollisionShape2D
onready var duck_collider: CollisionShape2D = $DuckCollisionShape2D
onready var momentum := $Momentum
onready var stats := $Stats
onready var hitbox: Hitbox = $Hitbox as Hitbox
onready var muzzle := $Skin/Muzzle
onready var muzzle_duck := $Skin/MuzzleDuck
onready var world_detector := $WorldDetector


func _ready() -> void:
	skin = get_node("Skin")
	switch_collision(CollisionType.STANDING)


func connect_camera(camera: Camera2D) -> void:
	$RemoteTransform2D.remote_path = camera.get_path()


func flip(direction: float) -> void:
	if direction == 0:
		return
	# warning-ignore:narrowing_conversion
	look_direction = sign(direction)
	skin.scale.x = look_direction


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.set_deferred("disabled", not value)


func set_is_handling_input(value: bool) -> void:
	state_machine.set_process_unhandled_input(value)
	is_handling_input = value


func switch_collision(type: int) -> void:
	if type == CollisionType.DUCKING:
		duck_collider.disabled = false
		collider.disabled = true
		return
	duck_collider.disabled = true
	collider.disabled = false
