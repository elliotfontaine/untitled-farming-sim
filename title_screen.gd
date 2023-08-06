extends Node

#Variables to control what is displaying on the screen
@onready var main_menu_container = %MainMenuContainer
@onready var options_container = %OptionsContainer
@onready var credits_container = %CreditsContainer
@onready var bg_pan = $AnimationPlayer


signal level_changed(level_name)

@export var world_level: PackedScene = load("res://world/world.tscn")

#Sets up panning background and correct buttons displayed
func _ready():
	bg_pan.play("bg_panning")
	main_menu_container.visible = true
	options_container.visible = false
	credits_container.visible = false

# --------- PLAY BUTTON ---------
#--------------------------------

## Switches from main menu to main scene when player presses play button
func _on_play_pressed():
	emit_signal("level_changed", world_level)
	#get_tree().change_scene_to_file()

# --------- OPTIONS CONTROL ---------
#------------------------------------

#Hides main menu and opens options menu when options button is pressed
func _on_options_pressed():
	main_menu_container.visible = false
	options_container.visible = true

#Hides options menu and returns view to main menu when back button is pressed
func _on_options_back_pressed():
	main_menu_container.visible = true
	options_container.visible = false

#Toggles game music on and off
func _on_music_button_toggled(button_pressed):
	if button_pressed:
		SoundHandler.can_play = false
		SoundHandler.stop_music()
	else:
		SoundHandler.can_play = true
		SoundHandler.play_music()

# --------- CREDITS BUTTON ---------
#-----------------------------------

#Displays credits when pressed
func _on_credits_pressed():
	main_menu_container.visible = false
	credits_container.visible = true

#Hides credit when pressed
func _on_credits_back_pressed():
	main_menu_container.visible = true
	credits_container.visible = false


# --------- EXIT BUTTON ---------
#--------------------------------

#Will close and exit the game when the exit button is pressed
func _on_quit_pressed():
	get_tree().quit()
