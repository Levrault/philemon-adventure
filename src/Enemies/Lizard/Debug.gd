extends Control


func _process(delta: float) -> void:
	$State.text = "State: %s" % owner.state_machine.state_name
