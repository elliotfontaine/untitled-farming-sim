extends Node2D

# TileMap references and layer constants
@onready var tile_map: TileMap = $TileMap
const GROUND_LAYER = 0
const COLLISION_LAYER = 1
const PLANT_LAYER = 2

# Custom data keys
const CAN_PLACE_SEED = "can_plant"
const CAN_HARVEST = "can_harvest"

# Predefined plant positions
const PLANT_0 = [
	Vector2i(14, 12),
	Vector2i(2, 14),
	Vector2i(14, 2),
	Vector2i(2, 2),
]

# UI references and harvest counter
@onready var rich_text_label: RichTextLabel = $RichTextLabel
var current_harvest: int = 0

# get the player 
@onready var player = $"../CharacterBody2D"

# ID of the source tile
var source_id: int = 6

const max_player_plant_dist : float = 50
var inRange : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with any initialization code if needed.

#func _process(_delta):
#	checkIfMouseInRangePlayer()

# Handle mouse input (left-click and right-click)
func _input(_event):
	checkIfMouseInRangePlayer()
	# Left-click (planting seeds)
	if Input.is_action_pressed("click") and inRange:
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		
		var atlas_coord: Vector2i = PLANT_0[0]
		
		var tile_data: TileData = tile_map.get_cell_tile_data(GROUND_LAYER, tile_mouse_pos)
		
		if tile_data:
			var can_place = tile_data.get_custom_data(CAN_PLACE_SEED)
			var hasnt_placed_something = tile_map.get_cell_tile_data(PLANT_LAYER, tile_mouse_pos)
			if can_place and !hasnt_placed_something:
				handle_seed(tile_mouse_pos, 0, atlas_coord, 4)

	# Right-click (harvesting)
	if Input.is_action_pressed("right_click") and inRange:
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		var tile_data: TileData = tile_map.get_cell_tile_data(PLANT_LAYER, tile_mouse_pos)
		if tile_data:
			var can_harvest_tile = tile_data.get_custom_data(CAN_HARVEST)
			if can_harvest_tile:
				tile_map.set_cell(PLANT_LAYER, tile_mouse_pos, -1)  # Remove the tile
				current_harvest += 1
				rich_text_label.text = "Money: " + str(current_harvest)

# Recursive function to plant seeds
func handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level):
	tile_map.set_cell(PLANT_LAYER, tile_mouse_pos, source_id, atlas_coord)
	
	await get_tree().create_timer(1.0).timeout  # Wait for 1 second

	if level == final_seed_level:
		return
	else:
		var next_level = level + 1
		var new_atlas: Vector2i = PLANT_0[next_level]
		handle_seed(tile_mouse_pos, next_level, new_atlas, 3)
		
func checkIfMouseInRangePlayer():
	# gets the mouse pos and calculates the distance of it to the player
	var distance = get_global_mouse_position().distance_to(player.global_position);
	
	# if the distance is greater than the placing range, then don't allow player to plant
	if distance > max_player_plant_dist:
		inRange = false
	else:
		inRange = true
