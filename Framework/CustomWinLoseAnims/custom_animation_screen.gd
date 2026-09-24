class_name CustomAnimationScreen extends Control

@export var sprite_frame_animator: AnimationPlayer

@warning_ignore("unused_signal")
signal anim_finished


func _ready() -> void:
	play_anim()


func play_anim() -> void:
	if sprite_frame_animator == null:
		push_warning("%s: sprite_frame_animator export var is null")
		anim_finished.emit()
		return
	sprite_frame_animator.play("default")
	await get_tree().create_timer(2.0).timeout
	anim_finished.emit()
