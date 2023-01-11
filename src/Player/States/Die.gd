extends State

export var throwback_force := Vector2(300, 300)

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


func enter(msg: Dictionary = {}) -> void:
	owner.visibility_notified.connect("screen_exited", self, "_on_Screen_exited")
	owner.is_active = false
	sfx.play()
	owner.set_collision_layer_bit(GameManager.LAYER.WORLD, false)
	owner.skin.queue(["hurt", "die"])
	owner.stats.set_invulnerable_for_seconds(2)
	
	_parent.throwback(throwback_force)
	
	if InputManager.is_using_gamepad():
		Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .450)


func exit() -> void:
	owner.set_collision_layer_bit(GameManager.LAYER.WORLD, true)
	owner.visibility_notified.disconnect("screen_exited", self, "_on_Screen_exited")


func _on_Screen_exited() -> void:
	_state_machine.transition_to("Spawn")
	owner.position = owner.spawn_position
