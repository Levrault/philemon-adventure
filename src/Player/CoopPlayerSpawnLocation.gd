extends Position2D


func _ready() -> void:
	yield(owner, "ready")
	GameMode.coop_player_spawn_location = self
