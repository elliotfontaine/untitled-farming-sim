extends CharacterBody2D

@export var wander_range : float = 5
@export var speed : int = 2

var currentPos : Vector2
var wanderPos : Vector2

var cow_left = preload("res://animals/cow-left.png")
var cow_right = preload("res://animals/cow-right.png")
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

func _ready():
	currentPos = position

func _physics_process(delta):
	velocity = wanderPos * speed
	if randi() % 60 == 0:
		get_new_wander_dir()
	if move_and_slide():
		wanderPos = Vector2(-wanderPos.x, -wanderPos.y)
	if wanderPos.x < 0:
		sprite_2d.texture = cow_left
		animation_player.play("cow_left")
	else:		
		sprite_2d.texture = cow_right
		animation_player.play("cow_right")

func get_new_wander_dir():
	var target_vector = Vector2(randf_range(-wander_range, wander_range),randf_range(-wander_range, wander_range))
	wanderPos = target_vector
