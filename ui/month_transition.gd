extends Control

signal exited

@onready var animation_player := $AnimationPlayer
@onready var season_tag := $Panel/Season/SeasonValue
@onready var food_tag := $Panel/Season/Cashflow/Food
@onready var taxes_tag := $Panel/Season/Cashflow/Taxes
@onready var random_tag := $Panel/Season/Cashflow/Random

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_player.play("fade_in_out")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_season_button_up():
	animation_player.play_backwards("fade_in_out")
	exited.emit()
