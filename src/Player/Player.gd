tool
extends Actor
class_name Player

enum CollisionType {
	STANDING, DUCKING, LADDER
}

const FLOOR_NORMAL := Vector2.UP
const SNAP := Vector2(0, 10)

export(Resource) var projectile_resource

var is_active := true setget set_is_active
var is_handling_input := true setget set_is_handling_input
var is_on_moving_platform := false
var initial_state_data := {}
var life := 3
var spawn_position := Vector2.ZERO
var ladder_position := Vector2.ZERO
var flag := {
	"ladder": false,
	"ladder_one_way_platform": false,
	"moving_platform": false
}

onready var collider: CollisionShape2D = $CollisionShape2D
onready var momentum := $Momentum
onready var hitbox: Hitbox = $Hitbox as Hitbox
onready var muzzle := $Skin/Muzzle
onready var world_detector := $WorldDetector
onready var visibility_notified := $VisibilityNotifier2D


func _ready() -> void:
	spawn_position = global_position


func connect_camera(camera: Camera2D) -> void:
	$RemoteTransform2D.remote_path = camera.get_path()


func take_damage(source: Hit) -> void:
	.take_damage(source)
	skin.hit_flash()
	if stats.health > 0 and not source.is_instakill:
		state_machine.transition_to("Move/Hurt", {impulse = true})
		return
	state_machine.transition_to("Move/Die")


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.set_deferred("disabled", not value)
	hitbox.set_is_active(value)


func set_is_handling_input(value: bool) -> void:
	state_machine.set_process_unhandled_input(value)
	is_handling_input = value
