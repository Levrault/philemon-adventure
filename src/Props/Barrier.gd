extends StaticBody2D


func open(msg := {}) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	
#	if "without_transition" in msg:
#		position = Vector2(0, -48)
#		return
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite, "position", Vector2(0, -48), 0.5)
