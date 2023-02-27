extends State

export var max_speed := 50

var velocity := Vector2.ZERO
var agent: NavigationAgent2D = null

onready var timer := $Timer
onready var steering_timer := $SteeringTimer


func _ready() -> void:
	yield(owner, "ready")
	agent = owner.navigation_agent
	agent.max_speed = max_speed


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if owner.target.global_position < owner.global_position:
		owner.flip(1)
	elif owner.target.global_position > owner.global_position:
		owner.flip(-1)
	
	var target_global_position := agent.get_next_location()
	var direction = owner.global_position.direction_to(target_global_position)

	var desiredvelocity = direction * max_speed
	var steering = (desiredvelocity - velocity) * delta * 4.0
	velocity += steering
	agent.set_velocity(velocity)
	velocity = owner.move_and_slide(velocity)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("move")
	timer.connect("timeout", self, "_on_Timeout_update_pathfinding")
	timer.start()
	steering_timer.connect("timeout", self, "_on_Timeout_steering")
	steering_timer.start()


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout_update_pathfinding")
	steering_timer.disconnect("timeout", self, "_on_Timeout_steering")
	steering_timer.stop()


func _on_Timeout_update_pathfinding() -> void:
	agent.set_target_location(owner.target.global_position)


func _on_Timeout_steering() -> void:
	_state_machine.transition_to("Steering")
