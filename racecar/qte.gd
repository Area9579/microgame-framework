extends Control

signal finished(success)

@export var keyString: String = "Spacebar"
@export var keyCode: Key = KEY_SPACE
@export var eventDuration := 0.5
@export var displayDuration := 0.5

@onready var circle = %Circle
@onready var key_label = %KeyLabel
@onready var success_label = %SuccessLabel


var tween = create_tween()
var success = false

func _ready() -> void:
	add_to_group("QTE")
	key_label.text = keyString
	
	await _animation()
	
	if not success:
		hide()

func _animation():
	tween.tween_property(circle, "material:shader_parameter/value", 0, eventDuration)
	
	await tween.finished

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(keyCode) and not success_label.visible:
		success_label.show()
		tween.kill()
		success = true
		
		await get_tree().create_timer(displayDuration).timeout
	
	hide()
