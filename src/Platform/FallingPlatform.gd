class_name FallingPlatform
extends KinematicBody2D


export var max_speed_default := Vector2(100.0, 325.00)
export var acceleration_default := Vector2(10000, 900.0)
export var decceleration_default := Vector2(10000, 1300.0)
export var max_speed_fall := 2000.00

var velocity: Vector2 = Vector2.ZERO

onready var falling_timer = $FallingTimer
onready var spawn_timer = $SpawnTimer
onready var initial_position = global_position
onready var animation_player = $AnimationPlayer
onready var collision_shape_2d = $CollisionShape2D


func _ready():
	falling_timer.connect("timeout", self, "_on_falling_timeout")
	spawn_timer.connect("timeout", self, "_on_spawn_timeout")
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity = Move.calculate_velocity(
		velocity, max_speed_default, acceleration_default, decceleration_default, delta, Vector2.DOWN
	)
	velocity = move_and_slide(velocity)


func active() -> void:
	falling_timer.start()


func inactive() -> void:
	falling_timer.stop()
	animation_player.play("active")


func _on_spawn_timeout() -> void:
	global_position = initial_position
	velocity = Vector2.ZERO
	animation_player.play("active")
	set_physics_process(false)


func _on_falling_timeout() -> void:
	animation_player.play("transition")
	spawn_timer.start()
