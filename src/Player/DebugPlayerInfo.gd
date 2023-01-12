extends Control


func _process(delta: float) -> void:
	$VBoxContainer/State.text = "State: %s" % owner.state_machine.state_name
	$VBoxContainer/FlagLadder.text = "Ladder: %s" % owner.flag.ladder
	$VBoxContainer/MovingPlatform.text = "MovingPlatform: %s" % owner.flag.moving_platform
	$VBoxContainer/LadderOneWayPlatform.text = "LadderOneWayPlatform: %s" % owner.flag.ladder_one_way_platform
	$VBoxContainer/LadderPosition.text = "LadderPosition: %s" % owner.ladder_position
	$VBoxContainer/VerticalMove.text = "Vertical %s" % Move.get_vertical_move_direction()
	$VBoxContainer/HorizontalMove.text = "Horizontal %s" % Move.get_horizontal_move_direction()
	$VBoxContainer/IsOnFloor.text = "IsOnFloor %s" % owner.is_on_floor()
	$VBoxContainer/LookDirection.text = "LookDirection %s" % owner.look_direction
