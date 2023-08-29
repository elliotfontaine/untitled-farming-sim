extends Control

@onready var grid_container = $NinePatchRect/GridContainer
var slots

var normal_slot = preload("res://ui/assets/item_slot.png")
var clicked_slot = preload("res://ui/assets/clicked_slot.png")
@onready var worldMap = get_parent().get_parent()
var click_player_character

# Called when the node enters the scene tree for the first time.
func _ready():
	slots = grid_container.get_children()
	click_player_character = worldMap.get_node("ClickingPlayerCharacter")
#	print(slots)
	select_slot(0)

func reset_slots():
	for x in range(slots.size()):
		slots[x].set_texture_normal(normal_slot)
		
func select_slot(x : int):
	reset_slots()
	slots[x].set_texture_normal(clicked_slot)
	click_player_character.selected_crop = click_player_character.crop_strnames[x]

func _on_beet_slot_pressed():
	select_slot(0)


func _on_potato_slot_pressed():
	select_slot(1)


func _on_tomato_slot_pressed():
	select_slot(2)


func _on_french_beans_slot_pressed():
	select_slot(3)


func _on_pumpkin_slot_pressed():
	select_slot(4)


func _on_carrot_slot_pressed():
	select_slot(5)


func _on_onion_slot_pressed():
	select_slot(6)


func _on_cauliflower_slot_pressed():
	select_slot(7)


func _on_turnip_slot_pressed():
	select_slot(8)


func _on_wheat_slot_pressed():
	select_slot(9)
