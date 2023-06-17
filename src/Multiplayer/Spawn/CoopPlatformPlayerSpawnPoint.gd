extends Position2D

export(int, 1, 3) var coop_player_index := 1


func _ready():
	if coop_player_index == 1:
		GameMode.coop_player_1_spawn_location = self
		return
	if coop_player_index == 2:
		GameMode.coop_player_2_spawn_location = self
		return
	GameMode.coop_player_3_spawn_location = self
