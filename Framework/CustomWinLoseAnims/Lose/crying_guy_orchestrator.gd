extends Node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var crying_guy: WinLoseCustomAnimation = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play()
	play_anim()


func play_anim() -> void:
	await get_tree().create_timer(2.0).timeout
	crying_guy.finish()
