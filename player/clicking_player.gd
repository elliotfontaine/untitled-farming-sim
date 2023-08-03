extends Node2D

const MAX_PLAYER_PLANT_DIST : float = 30
const crop_strnames: Array[StringName] = [
	&"wheat",
	&"potato",
	&"tomato",
	&"turnip",
	&"carrot",
	&"cauliflower",
	&"french_beans",
	&"onion",
	&"pumpkin",
	&"beet",
]

# get the player 
@export var optional_char: CharacterBody2D

var selected_crop: StringName = &"wheat"
var has_character: bool
var in_range : bool = true

# TileMap reference
@onready var tile_map: TileMap = $"../WorldTileMap"

func _ready() -> void:
	has_character = optional_char is CharacterBody2D
	print("The ClickingPlayer has no character attached.
		Proceding working with infinite range.")

func _process(delta) -> void:
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
		SoundHandler.play_sound(0)

## Docstring
func _handle_key_press(event: InputEventKey) -> void:
	if event.is_action_pressed("grow_crops"):
		for crop in tile_map.crop_instances.values():
			crop.grow(67)
	else:
		# Check for numerical keys
		for i in range(10):
			if event.is_action_pressed(str("slot_", i)):
				selected_crop = crop_strnames[i]

## Docstring
func is_mouse_in_range() -> bool:
	# gets the mouse pos and calculates the distance of it to the player
	var distance = get_global_mouse_position().distance_to(
		optional_char.global_position);
	return distance < MAX_PLAYER_PLANT_DIST
