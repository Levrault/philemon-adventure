extends State

export var max_force_default := 150.0
export var force_default := 90.0
export var min_wait_time := 0.250
export var max_wait_time := 0.300

var force := force_default
var wait_time := min_wait_time

onready var timer := $Timer
onready var cooldown := $Cooldown


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	_parent.velocity = owner.move_and_slide(Vector2(owner.look_direction, 0) * force, owner.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("slide")
	timer.connect("timeout", self, "_on_Timer_timeout")
	owner.switch_collision(Player.CollisionType.DUCKING)

	if "max_force" in msg:
		force = max_force_default
		timer.wait_time = max_wait_time
	
	timer.start()


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timer_timeout")
	force = force_default
	timer.wait_time = min_wait_time
	owner.switch_collision(Player.CollisionType.STANDING)


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Move/Idle")
	cooldown.start()
