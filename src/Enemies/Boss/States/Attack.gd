extends State

var max_speed := 200
var velocity := Vector2.ZERO
var start_attack := false

onready var timer = $Timer


func physics_process(delta: float) -> void:
	if not start_attack:
		return
	if owner.floor_detector.is_colliding():
		Events.emit_signal("camera_shake")
		_state_machine.transition_to("RecoverAttack")
		return
	velocity = Vector2(0, max_speed * owner.speed_multiplier)
	velocity = owner.move_and_slide(velocity)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("loading_attack")
	owner.floor_detector.enabled = true
	start_attack = false
	timer.connect("timeout", self, "_on_Timeout")
	timer.wait_time = 1.0
	timer.start()


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout")
	owner.floor_detector.enabled = false
	start_attack = false


func _on_Timeout() -> void:
	start_attack = true
	owner.skin.play("attack")
