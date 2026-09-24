extends Node2D
@onready var _head = $PixelyGuyHead
@onready var _body = $PixelyGuyBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_head.play("talking-head")
	_body.play("talking-body")
