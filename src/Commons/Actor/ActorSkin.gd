# Should manage all the sprite/animation of an Actor
# Create to be controller by the owner
class_name ActorSkin
extends Node2D

signal animation_finished(anim_name)
signal attack_triggered
signal damage_source_enabled
signal damage_source_disabled

var current_anim := "RESET"
var default_playback_speed := 1.0

onready var anim: AnimationPlayer = $AnimationPlayer
onready var sprite := $Sprite


func _ready() -> void:
	anim.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	default_playback_speed = $AnimationPlayer.playback_speed


func hit_flash() -> void:
	var tween = create_tween()
	tween.tween_property(sprite.get_material(), "shader_param/active", true, .15)
	tween.tween_property(sprite.get_material(), "shader_param/active", false, .15)


func freeze() -> void:
	anim.playback_speed = 0.0


func unfreeze() -> void:
	anim.playback_speed = default_playback_speed


func play(anim_name: String) -> void:
	assert(anim_name in anim.get_animation_list())
	current_anim = anim_name
	anim.play(anim_name)


func stop() -> void:
	anim.stop()


func seek(second: float, update:= true) -> void:
	anim.seek(second, update)


func queue(animations: Array) -> void:
	for anim_name in animations:
		assert(anim_name in anim.get_animation_list())
	
	anim.play(animations.pop_front())
	for anim_name in animations:
		anim.queue(anim_name)


func get_animation(anim_name: String) -> Animation:
	return anim.get_animation(anim_name)


# Gate to let the owner and the skin node communicate
# @param {String} anim_name
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
