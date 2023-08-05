extends Control

@export var title_screen: PackedScene = load("res://title_screen.tscn") 

@onready var menu_ui = %MenuUI
@onready var options_menu = %OptionsMenu
@onready var buttons_menu = %ButtonsMenu
@onready var background: ColorRect = $Background
@onready var music = "res://sounds/SoundScene.tscn"

var is_open : bool = false


#MAKES SURE PAUSE MENU IS CLOSED ON READY
func _ready():
	menu_ui.visible = false
	background.visible = false
	

#ALLOWS PAUSE MENU TO BE TOGGLED WITH ESC KEY
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not is_open:
			OpenMenu()
		else:
			CloseMenu()

#MAKES PAUSE MENU VISIBLE, PAUSES GAME
func OpenMenu():
		is_open = true
		menu_ui.visible = true
		background.visible = true
		buttons_menu.visible = true
		options_menu.visible = false
		get_tree().paused = true

#MAKES PAUSE MENU INVISIBLE, UNPAUSES GAME
func CloseMenu():
		is_open = false
		menu_ui.visible = false
		background.visible = false
		get_tree().paused = false

#EXITS GAME WHEN QUIT BUTTON IS PRESSED
func _on_exit_pressed():
	var world = get_node("/root/Game/World")
	if world and world.has_signal("level_changed"):
		CloseMenu()
		world.emit_signal("level_changed", title_screen)


#OPENS OPTIONS MENU
func _on_options_pressed():
	options_menu.visible = true
	buttons_menu.visible = false

#TOGGLES GAME MUSIC ON AND OFF
func _on_music_toggle_toggled(button_pressed):
	if button_pressed:
		SoundHandler.can_play = false
		SoundHandler.stop_music()
	else:
		SoundHandler.can_play = true
		SoundHandler.play_music()

#RETURNS OPTION MENU BACK TO MAIN PAUSE MENU
func _on_back_button_pressed():
	options_menu.visible = false
	buttons_menu.visible = true
