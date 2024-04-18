extends HBoxContainer


func _ready() -> void:
	Events.connect("card_unlocked", self, "_on_Card_unlocked")
	
	for child in get_children():
		child.hide()
	unlock()


func unlock() -> void:
	if GameManager.is_card_upgrade_status_unlocked(GameManager.Card.LVL_1):
		get_node("LVL_1").show()
	if GameManager.is_card_upgrade_status_unlocked(GameManager.Card.LVL_2):
		get_node("LVL_2").show()
	if GameManager.is_card_upgrade_status_unlocked(GameManager.Card.LVL_3):
		get_node("LVL_3").show()
	if GameManager.is_card_upgrade_status_unlocked(GameManager.Card.LVL_4):
		get_node("LVL_4").show()


func _on_Card_unlocked(card_type: int) -> void:
	unlock()
