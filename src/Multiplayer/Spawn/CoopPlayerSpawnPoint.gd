extends Node2D

const TIME_BEFORE_PLATFORM_QUEUE_FREE := 1
const INTERPOLATION_WEIGHT = 6
const FLOAT_TWEEN_DURATION = 1
const DELAY_ON_RESPAWN = 5

var device_index := -1
var target: Position2D = null
var tween_player: SceneTreeTween = null
var tween_platform: SceneTreeTween = null
var safe_check := false
var delay_time := 0

onready var coop_player: CoopPlayer = $CoopPlayer
onready var platform = $Platform
onready var safe_zone: Area2D = $SafeZone
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var safe_check_timer: Timer = $SafeCheckTimer
onready var gamepad_atlas_icon: TextureRect = $GamepadAtlasIcon
onready var delay_timer: Timer = $DelayTimer
onready var delay_label: Label = $DelayLabel


func _ready() -> void:
	Events.connect("coop_player_removed", self, "_on_Player_coop_removed")
	if delay_time > 0:
		delay_timer.connect("timeout", self, "_on_Delay_timeout")
		delay_label.text = "%s" % delay_time
		delay_timer.start()
		delay_label.show()
	else:
		safe_check_timer.connect("timeout", self, "_on_SafeCheck_timeout")
		safe_check_timer.start()
		delay_label.hide()
	
	set_process_input(false)
	gamepad_atlas_icon.hide()
	
	coop_player.device_index = device_index
	coop_player.is_handling_input = false
	coop_player.is_active = false
	GameMode.coop_players.append(coop_player.device_index)
	
	tween_platform = create_tween().set_loops(0)
	tween_platform.tween_property(platform, "position", Vector2(platform.position.x, platform.position.y + 2), FLOAT_TWEEN_DURATION)
	tween_platform.chain().tween_property(platform, "position", Vector2(platform.position.x, platform.position.y - 2), FLOAT_TWEEN_DURATION)
	
	tween_player = create_tween().set_loops(0)
	tween_player.tween_property(coop_player, "position", Vector2(coop_player.position.x, coop_player.position.y + 2), FLOAT_TWEEN_DURATION)
	tween_player.chain().tween_property(coop_player, "position", Vector2(coop_player.position.x, coop_player.position.y - 2), FLOAT_TWEEN_DURATION)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump_%s" % device_index):
		enable_coop_player()
		return


func _physics_process(delta: float) -> void:
	if not target:
		return
	global_position = lerp(global_position, target.global_position, INTERPOLATION_WEIGHT * delta)
	
	if not safe_check:
		return
	
	if safe_zone.get_overlapping_bodies().empty():
		
		# if overlapping with other coop player
		for area in safe_zone.get_overlapping_areas():
			if area is CoopPlayereSpawnPointSafeZone:
				return
		
		print_debug("player %s can now be possessed" % device_index)
		target = null
		animation_player.play("available")
		gamepad_atlas_icon.show()
		set_process_input(true)


func active_delay() -> void:
	delay_time = DELAY_ON_RESPAWN


func enable_coop_player() -> void:
	coop_player.is_active = true
	coop_player.set_deferred("is_handling_input", true)
	tween_player.kill()
	tween_platform.stop()
	gamepad_atlas_icon.queue_free()
	set_process_input(false)
	set_physics_process(false)
	
	tween_platform = create_tween().set_loops(10).set_trans(Tween.TRANS_SINE)
	tween_platform.tween_property(platform, "modulate:a", .2, .25)
	tween_platform.chain().tween_property(platform, "modulate:a", 1.0, .25)
	
	var tween_queue_free := create_tween().set_trans(Tween.TRANS_SINE)
	tween_queue_free.tween_callback(self, "remove_platform").set_delay(TIME_BEFORE_PLATFORM_QUEUE_FREE)


func remove_platform() -> void:
	tween_platform.kill()
	platform.queue_free()


func _on_SafeCheck_timeout() -> void:
	safe_check = true


func _on_Delay_timeout() -> void:
	delay_time -= 1
	if delay_time > 0:
		delay_label.text = "%s" % delay_time
		return
	delay_label.hide()
	delay_timer.stop()
	delay_timer.disconnect("timeout", self, "_on_Delay_timeout")
	safe_check_timer.connect("timeout", self, "_on_SafeCheck_timeout")
	safe_check_timer.start()


func _on_Player_coop_removed(index: int) -> void:
	if device_index != index:
		return
	queue_free()
