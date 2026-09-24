extends Node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var computer_guy: WinLoseCustomAnimation = $".."

func _ready() -> void:
	do_anim()


func do_anim() -> void:
	animated_sprite_2d.play()
	await get_tree().create_timer(2.0).timeout
	computer_guy.finish()
