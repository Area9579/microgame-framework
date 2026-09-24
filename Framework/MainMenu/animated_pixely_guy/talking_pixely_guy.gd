extends Node2D
@onready var _head = %PixelyGuyHead
@onready var _body = %PixelyGuyBody
@onready var clickable_area: Area2D = $ClickableArea as Area2D

@onready var squish: ControlTween = $Control/Squish as ControlTween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_head.play("talking-head")
	_body.play("talking-body")
	clickable_area.input_event.connect(clicked)


func clicked(_viewport : Node, event : InputEvent, _shape_inx : int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		squish.do_tween()
	
	
