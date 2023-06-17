extends State
class_name PlayerDie

export var throwback_force := Vector2(400, 400)

onready var sfx := $Sfx


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


func enter(msg: Dictionary = {}) -> void:
	owner.is_handling_input = false
	owner.visibility_notified.connect("screen_exited", self, "_on_Screen_exited")
	sfx.play()

	owner.skin.queue(["hurt", "die"])
	owner.stats.set_invulnerable_for_seconds(2)
	
	_parent.throwback(throwback_force)
	
	for layer in GameManager.LAYER.values():
		owner.set_collision_layer_bit(layer, false)
	
	if InputManager.is_using_gamepad():
		print_debug("start_joy_vibration")
		Input.start_joy_vibration(owner.device_index, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .450)


func exit() -> void:
	for layer in GameManager.LAYER.values():
		owner.set_collision_layer_bit(layer, true)
	owner.visibility_notified.disconnect("screen_exited", self, "_on_Screen_exited")


func _on_Screen_exited() -> void:
	_state_machine.transition_to("Spawn")
	GameManager.player_died()
