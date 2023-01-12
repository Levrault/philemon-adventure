extends State

const FRAME_BUFFERING := 2

export var velocity := Vector2(0, 55)
var frame := 0


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = true })
		return


func physics_process(delta: float) -> void:
	if not owner.flag.ladder:
		_state_machine.transition_to("Move/Idle")
		return
	
	if frame == FRAME_BUFFERING:
		owner.set_collision_layer_bit(GameManager.LAYER.WORLD, true)
		owner.world_detector.connect("body_entered", self, "_on_Body_entered")
	if frame <= (FRAME_BUFFERING + 1):
		frame += 1
	
	var direction := Move.get_vertical_move_direction()
	owner.move_and_collide(velocity * direction * delta)
	
	if direction.y == 0:
		owner.skin.freeze()
	else:
		owner.skin.unfreeze()


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("climbing")
	owner.global_position.x = owner.ladder_position.x
	frame = -1
	
	if "climb_from_top" in msg:
		owner.set_collision_layer_bit(GameManager.LAYER.WORLD, false)
		frame = 0


func exit() -> void:
	owner.skin.unfreeze()
	frame = -1
	owner.set_collision_layer_bit(GameManager.LAYER.WORLD, true)
	if owner.world_detector.is_connected("body_entered", self, "_on_Body_entered"):
		owner.world_detector.disconnect("body_entered", self, "_on_Body_entered")


func _on_Body_entered(body: Node) -> void:
	if not body is TileMap:
		return
	_state_machine.transition_to("Move/Idle")

