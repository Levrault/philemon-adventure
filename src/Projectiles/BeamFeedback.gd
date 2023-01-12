extends Node2D


func play_impact_sfx(body: Node):
	if body is Actor:
		$ImpactActor.play()
		return
	$ImpactObject.play()
