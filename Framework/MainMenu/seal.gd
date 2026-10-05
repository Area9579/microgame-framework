class_name seal 
extends RigidBody2D
@onready var roof: CollisionShape2D = $"../Area2D2/Roof"

@onready var guhhh: AudioStreamPlayer2D = $"../GUHHH"
@onready var reshape: Node2DTween = $reshape
@onready var squash: Node2DTween = $squash
@onready var floor: CollisionShape2D = $"../Area2D5/Floor"
@onready var squash_vert: Node2DTween = $squash_vert
@onready var reshape_vert: Node2DTween = $reshape_vert

var was_touching = false
var speed = 300
var speed_min = 200 
var speed_max = 400
var spawned := false
var saved_layer: int
var saved_mask: int



func _ready() -> void:
	gravity_scale = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	linear_damp = 0
	
	
	
	var material = PhysicsMaterial.new()
	material.bounce = 1.0
	material.friction = 0
	physics_material_override = material
	
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(collide)
	
	saved_layer = collision_layer
	saved_mask = collision_mask
	collision_layer = 0
	collision_mask = 0
	hide()
	freeze = true
	
	

func spawn() -> void:
	if spawned:
		return
	collision_layer = saved_layer
	collision_mask = saved_mask
	freeze = false
	show()
	linear_velocity = Vector2(1, 1).normalized() * speed
	
func _integrate_forces(state):
	var touching = state.get_contact_count() > 0
	if touching and not was_touching:
		var normal = state.get_contact_local_normal(0)
		print(normal, " ", state.get_contact_collider_object(0))
		if absf(normal.x) > absf(normal.y):
			squash_vert.do_tween()
			reshape.do_tween()
			guhhh.play(.5)
			print("hit wall")
		else:
			
			reshape_vert.do_tween()
			guhhh.play(.5)
			print ("hit floor")
			
			
	was_touching = touching
	
	
	if state.linear_velocity.length() > 0:
		state.linear_velocity = state.linear_velocity.normalized() * speed
	
	

func collide(body):
	if body is StaticBody2D and roof:


		speed = randf_range(speed_min,speed_max)


	
		
