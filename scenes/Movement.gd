extends CharacterBody2D

var speed = 5

func _physics_process(delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	motion = motion.normalized() * speed
	print(motion)
	
	if motion != Vector2.ZERO:
		velocity = motion
	else:
		velocity = Vector2.ZERO
	
	move_and_collide(motion * delta * speed)
