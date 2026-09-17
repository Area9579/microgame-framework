extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var timing = 0
const time_max = 30
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if timing >= time_max:
			position.y += 32
			timing = 0
		else:
			timing += 60 * delta 

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide() 
	if Input.is_action_just_pressed("left_click"):
		print("hi")
		position.x += 32
	if Input.is_action_just_pressed("a"):
		position.x -= 1
	if Input.is_action_just_pressed("d"):
		position.x += 1
