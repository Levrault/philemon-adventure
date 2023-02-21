extends State

onready var vision: Area2D = $Vision


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")
	vision.connect("body_entered", self, "_on_Body_entered")


func exit() -> void:
	return


func _on_Body_entered(body: Node) -> void:
	owner.target = body
	_state_machine.transition_to("Steering")
