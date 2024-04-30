extends State

var tween: SceneTreeTween

func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	tween = create_tween().set_loops()
	owner.skin.play("idle")
	tween.tween_property(owner, "position", (owner.position + Vector2(0, 2)), 1)
	tween.tween_property(owner, "position", (owner.position + Vector2(0, -2)), 1)


func exit() -> void:
	tween.stop()
	return


