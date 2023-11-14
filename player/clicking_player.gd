extends Node2D

const MAX_PLAYER_PLANT_DIST : float = 100
const crop_strnames: Array[StringName] = [
	&"beet",
	&"potato",
	&"tomato",
	&"french_beans",
	&"pumpkin",
	&"carrot",
	&"onion",
	&"cauliflower",
	&"turnip",
	&"wheat",
]

# get the player 
@export var optional_char: CharacterBody2D

var selected_crop: StringName
var has_character: bool
var in_range : bool = true
## Temporary solution for player data: a dictionary that keeps everything.
## Should be copied by the save system if implemented.
var player_data: Dictionary = {
	# Crop stocks
	"beet_stock": 0,
	"potato_stock": 0,
	"tomato_stock": 0,
	"french_beans_stock": 0,
	"pumpkin_stock": 0,
	"carrot_stock": 0,
	"onion_stock": 0,
	"cauliflower_stock": 0,
	"turnip_stock": 0,
	"wheat_stock": 0,
	# Money
	"money": 0,
	# Cows (producers) and manure (product)
	"cows": 0,
	"manure_stock": 0
}

# TileMap reference
@onready var tile_map: TileMap = $"../WorldTileMap"
@onready var hotbar = $"../HUD/HotBar"

func _ready() -> void:
	selected_crop = crop_strnames[0]
	has_character = optional_char is CharacterBody2D
	if not has_character: 
		print("The ClickingPlayer has no character attached. Proceding working with infinite range.")
	

func _process(_delta) -> void:
	pass

func _unhandled_input(event) -> void:
	# Only check for range if character present.
	if event is InputEventMouse:
		_handle_mouse_click(event)
	elif event is InputEventKey:
		_handle_key_press(event)
	
## Docstring
func _handle_mouse_click(event: InputEventMouse) -> void:
	if has_character:
		in_range = is_mouse_in_range()
	if not in_range:
		tile_map.set_tile_selector(tile_map.DEFAULT_SELECTOR_POS)
		return
	# get mouse position and convert it to tilemap coords
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
	# Handle the event
	if event is InputEventMouseMotion:
		tile_map.set_tile_selector(tile_mouse_pos)
	elif event.is_action_pressed("add_crop"):
		tile_map.add_crop(tile_mouse_pos, selected_crop)
		SoundHandler.play_sound(0)
	elif event.is_action_pressed("remove_crop"):
		tile_map.remove_crop(tile_mouse_pos)
		SoundHandler.play_sound(1)

## Docstring
func _handle_key_press(event: InputEventKey) -> void:
	if event.is_action_pressed("grow_crops"):
		for crop in tile_map.crop_instances.values():
			crop.grow(67)
	else:
		# Check for numerical keys
		for i in range(10):
			if event.is_action_pressed(str("slot_", i)):
				selected_crop = crop_strnames[i-1]
				hotbar.select_slot(i-1)
			elif event.is_action_pressed(str("slot_10")): #special hardcoded exception
				selected_crop = crop_strnames[9]
				hotbar.select_slot(9)

## Docstring
func is_mouse_in_range() -> bool:
	# gets the mouse pos and calculates the distance of it to the player
	var distance = get_global_mouse_position().distance_to(
		optional_char.global_position);
	return distance < MAX_PLAYER_PLANT_DIST
