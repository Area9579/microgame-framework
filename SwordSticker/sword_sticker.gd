extends MicroGame

const STICKER = preload("res://SwordSticker/sticker.tscn")
@onready var stick_point: Vector2 = $StickPoint.get_global_position()
@onready var counter_label: Label = $LoseTimer/CounterLabel
@onready var lose_timer: Timer = $LoseTimer

var projectile: Sprite2D
@onready var proj_point: Vector2 = $ProjPoint.get_global_position()

@onready var spin_world: Sprite2D = $SpinWorld
var speed : float = 1
@export var proj_speed : int = 1000
var proj_moving : bool = false

@onready var center: Node2D = $Center
const ENEMY = preload("res://SwordSticker/enemy.tscn")
const VILLAGER = preload("res://SwordSticker/villager.tscn")

var count : int = 10

func _ready() -> void:
	create_projectile()
	speed *= exp(difficulty)
	create_enemies(int(difficulty * 5 + 4))
	create_villagers(int(difficulty * 6 + 3))
	
	lose_timer.start()

func win():
	GameManager.win()
	
func lose():
	GameManager.lose()

func _process(delta: float) -> void:
	spin_world.rotate(speed * delta)
	
	if proj_moving:
		projectile.set_position(
			projectile.get_position().move_toward(
				stick_point,proj_speed*delta))
		if projectile.get_position() == stick_point:
			create_spinner_sticker()
			projectile.queue_free()
			proj_moving = false
			
			create_projectile()
			
	elif Input.is_action_just_pressed("space") and projectile:
		proj_moving = true
		

func create_spinner_sticker():
	var sticker = STICKER.instantiate()
	sticker.get_child(0).queue_free()
	spin_world.add_child(sticker)
	sticker.set_global_position(stick_point)
	sticker.rotation -= spin_world.rotation

func create_projectile():
	var sticker = STICKER.instantiate()
	add_child(sticker)
	sticker.set_global_position(proj_point)
	projectile = sticker

func create_enemies(num : int):
	for _i in range(0,num):
		var enemy = ENEMY.instantiate()
		center.add_child(enemy)
		enemy.rotate(spin_world.rotation)
		var rads = deg_to_rad(randi_range(1,360))
		var dist = spin_world.get_global_position().distance_to(stick_point)
		enemy.set_position(polar_to_cartesian(rads,dist))
		
func create_villagers(num : int):
	for _i in range(0,num):
		var villager = VILLAGER.instantiate()
		center.add_child(villager)
		villager.rotate(spin_world.rotation)
		var rads = deg_to_rad(randf_range(1,360))
		var dist = spin_world.get_global_position().distance_to(stick_point)
		villager.set_position(polar_to_cartesian(rads,dist))
	
func polar_to_cartesian(radians : float, dist : float):
	return Vector2(dist * cos(radians),dist * sin(radians))
	

func _on_lose_timer_timeout() -> void:
	count -= 1
	counter_label.text = "Seconds Left: " + str(count)
	if count <= 0:
		lose()

func increase_count() -> void:
	counter_label.text = "Seconds Left: " + str(count) + "\n BONUS! +1"
	count += 1

func decrease_count() -> void:
	counter_label.text = "Seconds Left: " + str(count) + "\n PENALTY! -1"
	count -= 1
