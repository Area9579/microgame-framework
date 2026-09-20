extends Node2D

@export var popup_scene: PackedScene
@export var ui_layer: Node 
@onready var timer: Timer = $Timer
@onready var terminal_sfx = $AudioStreamPlayer

func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	if popup_scene and ui_layer:
		var new_popup = popup_scene.instantiate()
		
		# Radomize scale of terminal
		var random_scale = randf_range(0.75, 1)
		new_popup.scale = Vector2(random_scale, random_scale)
		
		# Randomize where it appears on the viewport screen
		var screen_size = get_viewport().get_visible_rect().size
		new_popup.global_position = Vector2(
			randf_range(25, screen_size.x - 475),
			randf_range(25, screen_size.y - 300)
		)
				
		# Add it as a child of your UI container so it renders on top
		ui_layer.add_child(new_popup)
		
		# SFX
		terminal_sfx.play()
		
		# Increments current scene count
		Globals.current_terminal_count += 1
