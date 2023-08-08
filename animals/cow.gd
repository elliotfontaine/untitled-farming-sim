extends CharacterBody2D

@export var wander_range : float = 5
@export var speed : int = 5

var currentPos : Vector2
var wanderPos : Vector2

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	currentPos = position

func _physics_process(_delta):
	velocity = wanderPos * speed
	if randi() % 60 == 0:
		get_new_wander_dir()
	if move_and_slide():
		wanderPos = Vector2(-wanderPos.x, -wanderPos.y)
	if wanderPos.x < 0:
		sprite_2d.set_flip_h(true)
		animation_player.play("cow")
	elif wanderPos.x > 0:		
		sprite_2d.set_flip_h(false)
		animation_player.play("cow")
	if randi() % 600 == 0:
		audio_stream_player_2d.play()

func get_new_wander_dir():
	var target_vector = Vector2(randf_range(-wander_range, wander_range),randf_range(-wander_range, wander_range))
	wanderPos = target_vector
