extends Node2D

# TileMap reference
@onready var tile_map: TileMap = $"../WorldTileMap"

# get the player 
@export var optional_char: CharacterBody2D

const MAX_PLAYER_PLANT_DIST : float = 30
var in_range : bool = true
var has_character: bool

func _ready() -> void:
	has_character = optional_char is CharacterBody2D
	print("The ClickingPlayer has no character attached.
		Proceding working with infinite range.")

func _unhandled_input(_event) -> void:
	# Only check for range if character present.
	if has_character:
		in_range = is_mouse_in_range()
	if not in_range:
		return
	# get mouse position and convert it to tilemap coords
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
	if Input.is_action_pressed("add_crop"):
		tile_map.add_crop(tile_mouse_pos, &"wheat")
	elif Input.is_action_pressed("remove_crop"):
		tile_map.remove_crop(tile_mouse_pos)
	elif Input.is_action_pressed("grow_crops"):
		for crop in tile_map.crop_instances.values():
			crop.grow(120)

func is_mouse_in_range() -> bool:
	# gets the mouse pos and calculates the distance of it to the player
	var distance = get_global_mouse_position().distance_to(
		optional_char.global_position);
	return distance < MAX_PLAYER_PLANT_DIST
