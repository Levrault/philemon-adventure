extends ActorSkin

const PLAYER_1_SPRITE = preload("res://assets/characters/player/player_1-Sheet.png")
const PLAYER_2_SPRITE = preload("res://assets/characters/player/player_2-Sheet.png")
const PLAYER_3_SPRITE = preload("res://assets/characters/player/player_3-Sheet.png")


func set_skin_by_device_index(idx: int) -> void:
	var id = GameMode.coop_skins.get(idx, 0)
	
	match (id):
		GameMode.PlayerSkin.RED:
			sprite.texture = PLAYER_1_SPRITE
		GameMode.PlayerSkin.BLUE:
			sprite.texture = PLAYER_2_SPRITE
		GameMode.PlayerSkin.PINK:
			sprite.texture = PLAYER_3_SPRITE
