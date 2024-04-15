# Triggered during a navvigation between page
# transition_fade_mid_transition and transition_fade_finished are emitted from AnimationPlayer
# @category: Transition
extends Control

var rng = RandomNumberGenerator.new()

onready var anim := $AnimationPlayer
onready var sprite_material := $Sprite.material as Material
onready var timer := $Timer


func _ready() -> void:
	Events.connect("menu_transition_started", self, "_on_Transition_started")
	rng.randomize()


func emit_animation_finished() -> void:
	Events.emit_signal("menu_transition_finished")


func _on_Transition_started(anim_name: String) -> void:
	if anim.current_animation == "RESET":
		anim.stop()
		anim.play(anim_name)
		return
	sprite_material.set_shader_param("type", rng.randi_range(0, 4))
	anim.queue(anim_name)


func _on_Mid_animation() -> void:
	Events.emit_signal("menu_transition_mid_animated")
