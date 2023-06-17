extends Node

var slots := []


func _ready() -> void:
	owner.connect("page_open", self, "set_process_input", [true])
	owner.connect("page_closed", self, "set_process_input", [false])
	set_process_input(false)
	
	for slot in $"../Wrapper/Page/Contents/HBoxContainer".get_children():
		slots.append(slot)
	
	slots[0].is_locked = true


func _input(event: InputEvent) -> void:
	if not event is InputEventJoypadButton:
		return

	if event.is_action_pressed("jump_1") or event.is_action_pressed("jump_2") or event.is_action_pressed("jump_3"):
		for slot in slots:
			if not slot.is_locked:
				slot.lock(event.device)
				return
		return

	if event.is_action_pressed("cancel_1") or event.is_action_pressed("cancel_2") or event.is_action_pressed("cancel_3"):
		for slot in slots:
			if slot.is_locked and slot.device_index == event.device:
				slot.unlock()
				return
		return
