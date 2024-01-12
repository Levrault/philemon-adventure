tool
extends PanelContainer

export(GameMode.PlayerSkin) var skin := GameMode.PlayerSkin.ORANGE
export var is_locked := false setget set_is_locked
export var device_index := -1 setget set_device_index
var is_slot_free := false


func _ready() -> void:
	$"%SlotCanBeQuitContainer".hide()
	if device_index <= 0:
		$"%PlayerSkin".play("idle")


func set_is_locked(value: bool) -> void:
	is_locked = value

	if is_locked:
		$"%LockedContent".show()
		$"%FreeContent".hide()
		return
	$"%LockedContent".hide()
	$"%FreeContent".show()


func set_device_index(value: int) -> void:
	device_index = value
	$"%PlayerName".text = tr("Player ") + String(device_index + 1)
	
	# player 0 can't quit
	if device_index <= 0:
		$"%SlotCanBeQuitContainer".hide()
		return
	$"%SlotCanBeQuitContainer".show()


func lock(p_device_index: int) -> void:
	self.is_locked = true
	self.device_index = p_device_index
	GameMode.coop_skins[device_index] = skin
	$"%PlayerSkin".set_skin_by_device_index(p_device_index)
	$"%PlayerSkin".play("idle")
	GameMode.add_local_coop_player(device_index)


func unlock() -> void:
	self.is_locked = false
	self.device_index = -1
	$"%PlayerSkin".stop()
	
