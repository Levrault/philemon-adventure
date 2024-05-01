# when owner is hurt, he's throwback on the opposite direction
# and will be granted with some invinsible frame
extends State

const INVULNERABLE_TIME := .5

export var throwback_force := Vector2(200, 200)

onready var timer := $Timer
onready var sfx := $Impact


func physics_process(delta: float) -> void:
	var velocity = _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		_parent.acceleration,
		_parent.decceleration,
		delta,
		Vector2(owner.hit_direction, 1)
	)
	_parent.velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

	Events.emit_signal("player_moved", owner)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle", {contact = true})


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("hurt")
	owner.hitbox.set_collision_mask_bit(GameManager.LAYER.DAMAGE_SOURCE_PLAYER_LAYER, false)
	owner.is_snapped_to_floor = false
	owner.is_handling_input = false
	owner.momentum.start()
	sfx.play_sound()
	if InputManager.is_using_gamepad():
		print_debug("code joy vibration")
		#Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .3)

	if "impulse" in msg and msg.impulse:
		_parent.throwback(throwback_force)


func exit() -> void:
	owner.hitbox.set_collision_mask_bit(GameManager.LAYER.DAMAGE_SOURCE_PLAYER_LAYER, true)
	owner.is_handling_input = true
	owner.is_snapped_to_floor = true
	owner.stats.set_invulnerable_for_seconds(INVULNERABLE_TIME)
	_parent.velocity = Vector2.ZERO
