tool
extends Actor
class_name Player

const FLOOR_NORMAL := Vector2.UP
const SNAP := Vector2(0, 10)

export(Resource) var beam_resource
export(Resource) var hyper_beam_resource
export(Resource) var curved_beam_resource
export(GameManager.BeamType) var current_beam_type := GameManager.BeamType.BEAM setget set_current_beam_type

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
onready var beam_state_machine := $BeamStateMachine
onready var beam_fire_mode := $BeamFireMode


func _ready() -> void:
	visibility_notified.connect("screen_exited", self, "_on_Screen_exited")
	Events.connect("player_teleported_to", self, "_on_Player_teleported_to")
	Events.connect("player_input_disabled", self, "set_is_handling_input", [false])
	Events.connect("player_input_enabled", self, "set_is_handling_input", [true])
	Events.connect("save_data_started", self, "_on_Save_data_started")
	Events.connect("player_state_changed_to", self, "_on_Player_state_changed_to")
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


func set_current_beam_type(value: int) -> void:
	if value == current_beam_type:
		return
	current_beam_type = value
	muzzle.reset_cooldown()
	Events.emit_signal("beam_selected", value)


func set_is_handling_input(value: bool) -> void:
	state_machine.set_process_unhandled_input(value)
	is_handling_input = value


func has_charged_beam(beam_type: int) -> bool:
	match beam_type:
		GameManager.BeamType.BEAM:
			return true
		_:
			return false


func get_next_beam(beam_type: int) -> int:
	match beam_type:
		GameManager.BeamType.BEAM:
			return GameManager.BeamType.CURVED_BEAM
		_:
			return GameManager.BeamType.BEAM


func get_firing_beam_resource() -> Resource:
	match(current_beam_type):
		GameManager.BeamType.CURVED_BEAM:
			return curved_beam_resource
		_:
			return beam_resource


func get_charged_beam_resource() -> Resource:
	match(current_beam_type):
		GameManager.BeamType.BEAM:
			return hyper_beam_resource
		_:
			return beam_resource


func _on_Screen_exited() -> void:
	if stats.health > 0:
		state_machine.transition_to("Move/Die")


func _on_Player_teleported_to(global_position: Vector2) -> void:
	print_debug("Player has been teleported to %s" % global_position)
	self.global_position = global_position


func _on_Save_data_started() -> void:
	state_machine.transition_to("Spawn", { saving_data = true })


func _on_Player_state_changed_to(state: String, msg := {}) -> void:
	state_machine.transition_to(state, msg)
