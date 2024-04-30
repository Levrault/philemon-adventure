# Triggered during a navvigation between page
# transition_fade_mid_transition and transition_fade_finished are emitted from AnimationPlayer
# @category: Transition
extends Control

var rng = RandomNumberGenerator.new()

onready var anim := $AnimationPlayer
onready var sprite_material := $Sprite.material as Material


func _ready() -> void:
	Events.connect("menu_transition_started", self, "_on_Transition_started")


func emit_animation_finished() -> void:
	print_debug("Menu transition finished")
	Events.emit_signal("menu_transition_finished")


func _on_Transition_started() -> void:
	print_debug("Menu transition started")
	if anim.is_playing():
		Events.emit_signal("menu_transition_mid_animated")
	
	anim.stop()
	anim.play("fade")


func _on_Mid_animation() -> void:
	Events.emit_signal("menu_transition_mid_animated")
	print_debug("Mid Menu transition emitted")
	
