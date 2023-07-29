extends CharacterBody2D

#Variables for controlling player movement
var input_vector = Vector2.ZERO
const speed : float = 80.0

#variables for controlling player animations
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
var direction : String = "down_idle"





func _ready():
	anim.play("down_idle")

#function to control player movement
func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	#Sets up idle animations
	if velocity == Vector2.ZERO and direction == "left":
			anim.play("left_idle")
	elif velocity == Vector2.ZERO and direction == "right":
			anim.play("right_idle")
	elif velocity == Vector2.ZERO and direction == "up":
			anim.play("up_idle")
	elif velocity == Vector2.ZERO and direction == "down":
			anim.play("down_idle")

	#Sets up play movement animation
	if velocity.x < 0:
		anim.play("walk_left")
		direction = "left"
	elif velocity.x > 0:
		anim.play("walk_right")
		direction = "right"
	elif velocity.y < 0:
		anim.play("walk_up")
		direction = "up"
	elif velocity.y > 0:
		anim.play("walk_down")
		direction = "down"
	else:
		pass
		
	move_and_slide()
