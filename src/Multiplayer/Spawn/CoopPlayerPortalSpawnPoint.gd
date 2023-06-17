extends Position2D

export(int, 1, 3) var coop_player_index := 1


func _ready():
	if coop_player_index == 1:
		GameMode.coop_player_1_portal_spawn_location = self
	elif coop_player_index == 2:
		GameMode.coop_player_2_portal_spawn_location = self
	else:
		GameMode.coop_player_3_portal_spawn_location = self
