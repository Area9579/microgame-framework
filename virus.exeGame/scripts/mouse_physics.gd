extends Sprite2D

const CURSOR = preload("uid://dndn7ul1u6l0a")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(CURSOR)
	pass
