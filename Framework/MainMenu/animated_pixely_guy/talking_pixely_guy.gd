extends Node2D
@onready var _head = $PixelyGuyHead
@onready var _body = $PixelyGuyBody

@export var pulse_speed: float = .2
var current_hue: float = 0.0
func _process(delta: float) -> void:
	current_hue = fmod(current_hue + delta * pulse_speed, 1.0)
	var rainbow_color = Color.from_hsv(current_hue, 0.4, 0.8)
	_head.self_modulate = rainbow_color
	_body.self_modulate = rainbow_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_head.play("talking-head")
	_body.play("talking-body")
