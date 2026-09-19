extends Node2D

@export var popup_scene: PackedScene
@export var ui_layer: Node 
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	if popup_scene and ui_layer:
		var new_popup = popup_scene.instantiate()
		
		# (Optional) Randomize where it appears on the viewport screen
		var screen_size = get_viewport().get_visible_rect().size
		new_popup.global_position = Vector2(
			randf_range(25, screen_size.x - 475),
			randf_range(25, screen_size.y - 300)
		)
		
		# Add it as a child of your UI container so it renders on top
		ui_layer.add_child(new_popup)
