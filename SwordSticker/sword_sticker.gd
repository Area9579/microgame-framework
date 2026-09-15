extends MicroGame

const STICKER = preload("res://SwordSticker/sticker.tscn")
@onready var stick_point: Vector2 = $StickPoint.get_global_position()

var projectile: Sprite2D
@onready var proj_point: Vector2 = $ProjPoint.get_global_position()

@onready var sprite_2d: Sprite2D = $Sprite2D
var speed : float = 1
@export var proj_speed : int = 500
var proj_moving : bool = false

var count : int = 0

func _ready() -> void:
	create_projectile()
	speed *= exp(difficulty)

func win():
	GameManager.win()
	
func lose():
	GameManager.lose()

func _process(delta: float) -> void:
	sprite_2d.rotate(speed * delta)
	
	if proj_moving:
		projectile.set_position(
			projectile.get_position().move_toward(
				stick_point,proj_speed*delta))
		if projectile.get_position() == stick_point:
			create_spinner_sticker()
			projectile.queue_free()
			proj_moving = false
			
			count += 1
			if count == 3:
				win()
			create_projectile()
			
	elif Input.is_action_just_pressed("space") and projectile:
		proj_moving = true

func create_spinner_sticker():
	var sticker = STICKER.instantiate()
	sprite_2d.add_child(sticker)
	sticker.set_global_position(stick_point)
	sticker.rotation -= sprite_2d.rotation

func create_projectile():
	var sticker = STICKER.instantiate()
	add_child(sticker)
	sticker.set_global_position(proj_point)
	projectile = sticker
