class_name CustomAnimationScreen extends Control

@onready var sprite_frame_animator: AnimationPlayer = $SpriteFrameAnimator

@warning_ignore("unused_signal")
signal anim_finished


func _ready() -> void:
	sprite_frame_animator.play()


func finish() -> void:
	anim_finished.emit()
