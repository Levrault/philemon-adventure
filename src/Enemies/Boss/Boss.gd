tool
class_name Boss
extends KinematicBody2D

export (int, -1, 1, 2) var look_direction := 1 setget set_look_direction
export(NodePath) var left_attack_position_path
export(NodePath) var middle_attack_position_path
export(NodePath) var right_attack_position_path
export(Resource) var resource

var is_snapped_to_floor := false
var stop_on_slope := true
var left_attack_position: Position2D
var middle_attack_position: Position2D
var right_attack_position: Position2D
var targets = []
var target: Position2D 
var target_index := 0
var going_right = true
var speed_multiplier := 1.0

onready var stats: Stats = $Stats as Stats
onready var state_machine: StateMachine = $StateMachine
onready var skin: Node2D = $Skin
onready var floor_detector = $Skin/FloorDetector


func _ready() -> void:
	floor_detector.add_exception(self)
	left_attack_position = get_node(left_attack_position_path)
	middle_attack_position = get_node(middle_attack_position_path)
	right_attack_position = get_node(right_attack_position_path)
	targets = [left_attack_position, middle_attack_position, right_attack_position]
	target = left_attack_position
	flip(look_direction)


func active() -> void:
	state_machine.transition_to("Move")


func take_damage(source: Hit) -> void:
	stats.take_damage(source)
	
	if stats.health < 400 and stats.health > 250:
		speed_multiplier = 1.25
	elif stats.health < 250 and stats.health > 150:
		speed_multiplier = 1.5
	elif stats.health < 150:
		speed_multiplier = 2
	
	if stats.health > 0 and not source.is_instakill:
		skin.hit_flash()
		return
	state_machine.transition_to("Die")


func set_look_direction(value: int) -> void:
	look_direction = value
	
	if Engine.editor_hint:
		flip(look_direction)


func flip(direction:int = 0) -> void:
	if direction == 0 :
		return
	look_direction = int(sign(direction))
	skin.scale.x = skin.scale.x * look_direction


func change_target() -> void:
	if going_right and target_index == targets.size() - 1:
		going_right = false
	elif not going_right and target_index == 0:
		going_right = true
	
	if going_right:
		target_index += 1
	else:
		target_index -= 1
	target = targets[target_index]
