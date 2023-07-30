extends Node2D

# TileMap references and layer constants
@onready var tile_map: TileMap = $TileMap
const GROUND_LAYER = 0
const COLLISION_LAYER = 1
const PLANT_LAYER = 2

# Custom data keys
const CAN_PLACE_SEED = "can_plant"
const CAN_HARVEST = "can_harvest"

# UI references and harvest counter
@onready var rich_text_label: RichTextLabel = $RichTextLabel
var current_harvest: int = 0

# get the player 
@onready var player = $"../CharacterBody2D"

# ID of the source tile
var source_id: int = 6

const max_player_plant_dist : float = 50
var inRange : bool = true

func _input(_event):
	checkIfMouseInRangePlayer()
	if Input.is_action_pressed("click") and inRange:
		# get mouse position and convert it to tilemap coords
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		
		var tile_data: TileData = tile_map.get_cell_tile_data(GROUND_LAYER, tile_mouse_pos)
		
		if tile_data:
			var can_place = tile_data.get_custom_data(CAN_PLACE_SEED)
			var hasnt_placed_something = tile_map.get_cell_tile_data(PLANT_LAYER, tile_mouse_pos)
			if can_place and !hasnt_placed_something:
				tile_map.set_cell(2, tile_mouse_pos, 7, Vector2i.ZERO, 1)

func checkIfMouseInRangePlayer():
	# gets the mouse pos and calculates the distance of it to the player
	var distance = get_global_mouse_position().distance_to(player.global_position);

	# if the distance is greater than the placing range, then don't allow player to plant
	if distance > max_player_plant_dist:
		inRange = false
	else:
		inRange = true
		
