extends Control

@onready var menu_ui = %MenuUI 
var is_open : bool = false



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not is_open:
			OpenMenu()
		else:
			CloseMenu()
	
func OpenMenu():
		is_open = true
		menu_ui.visible = true
		get_tree().paused = true
		print(is_open)

func CloseMenu():
		is_open = false
		menu_ui.visible = false
		get_tree().paused = false
		print(is_open)


func _on_options_pressed():
	pass # Replace with function body.
