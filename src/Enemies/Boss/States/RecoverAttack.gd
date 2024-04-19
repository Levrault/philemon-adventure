extends State

export var max_speed := 200

var velocity := Vector2.ZERO
var can_recover = false
onready var timer = $Timer


func _ready() -> void:
	yield(owner, "ready")


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if not can_recover:
		return
	if owner.target.global_position.distance_to(owner.global_position) < 1:
		owner.change_target()
		_state_machine.transition_to("Move")
		return
	
	var target_global_position :Vector2 = owner.target.global_position
	var direction = owner.global_position.direction_to(target_global_position)

	var desiredvelocity = direction * max_speed
	var steering = (desiredvelocity - velocity) * delta * 4.0
	velocity += steering
	velocity = owner.move_and_slide(velocity)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")
	timer.connect("timeout", self, "_on_Timeout")
	timer.start()


func exit() -> void:
	timer.stop()
	timer.disconnect("timeout", self, "_on_Timeout")
	can_recover = false


func _on_Timeout() -> void:
	can_recover = true
