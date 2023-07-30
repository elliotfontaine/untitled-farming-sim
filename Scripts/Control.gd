extends Control

#Variables to control what is displaying on the screen
@onready var main_menu_container = %MainMenuContainer
@onready var options_container = %OptionsContainer


# --------- PLAY BUTTON ---------
#--------------------------------

#Switches from main menu to main scene when player presses play button
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")




# --------- OPTIONS CONTROL ---------
#------------------------------------

#Hides main menu and opens options menu when options button is pressed
func _on_options_pressed():
	main_menu_container.visible = false
	options_container.visible = true

#Hides options menu and returns view to main menu when back button is pressed
func _on_back_pressed():
	main_menu_container.visible = true
	options_container.visible = false



# --------- CREDITS BUTTON ---------
#-----------------------------------

#Will display the game credits when credits button is pressed
func _on_credits_pressed():
	pass 



# --------- EXIT BUTTON ---------
#--------------------------------

#Will close and exit the game when the exit button is pressed
func _on_exit_pressed():
	get_tree().quit()

