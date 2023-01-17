extends CanvasLayer
class_name LevelTransition

enum Transition {
	THEATRAL,
	WINDOW_BLIND_HORIZONTAL,
	WINDOW_BLIND_DIAGONAL,
	DOT,
	TRIANGLE
}

var can_fade_out := false

onready var material := $Sprite.material as Material
onready var timer := $Timer
onready var anim := $AnimationPlayer


func _ready() -> void:
	Events.connect("scene_fadeout_transition_displayed", self, "_on_Scene_fadeout_transition_displayed")
	Events.connect("scene_fadein_transition_displayed", self, "_on_Scene_fadein_transition_displayed")
	Events.connect("scene_loaded", self, "_on_Scene_loaded")
	anim.connect("animation_finished", self, "_on_Animation_finished")


func _on_Scene_fadeout_transition_displayed(type = Transition.DOT) -> void:
	material.set_shader_param("type", type)
	anim.play("fadeout")


func _on_Scene_fadein_transition_displayed(type = Transition.DOT) -> void:
	material.set_shader_param("type", type)
	anim.play("fadein")


func _on_Scene_loaded() -> void:
	anim.play("fadein")


func _on_Animation_finished(anim_name: String) -> void:
	if not anim_name == "fadeout":
		return
	LevelManager.change_for_next_scene()
