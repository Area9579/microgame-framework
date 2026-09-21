class_name VirusGame extends MicroGame

const CURSOR = preload("res://virus.exeGame/Assets/sprites/cursor.png")
var current_terminal_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(CURSOR)
