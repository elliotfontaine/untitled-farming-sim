extends Node2D

@onready var tile_map : TileMap = $TileMap

var ground_layer = 0
var collision_layer = 1
var plant_layer = 2

var can_place_seed = "can_plant"
var can_harvest = "can_harvest"

var plant_0 = [Vector2i(14, 12), Vector2i(2, 14), Vector2i(14,2), Vector2i(2,2)]

@onready var rich_text_label = $RichTextLabel
var current_harvest = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		
func _input(event):
	if Input.is_action_pressed("click"):
			
		var mouse_pos = get_global_mouse_position() # get mouse position in float coords
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos) # convert it to tilemap coords
		
		var source_id = 4
		
		var atlas_coord : Vector2i = plant_0[0]
		
		var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_mouse_pos)
		
		if tile_data:
			var can_place = tile_data.get_custom_data(can_place_seed)
			var hasnt_placed_something = tile_map.get_cell_tile_data(plant_layer, tile_mouse_pos) #returns null if nothing there
			if can_place and !hasnt_placed_something:
				handle_seed(tile_mouse_pos, 0, atlas_coord, 4)
					
	if Input.is_action_pressed("right_click"): #is the checkmark button checked
			var mouse_pos = get_global_mouse_position() # get mouse position in float coords
			var tile_mouse_pos = tile_map.local_to_map(mouse_pos) # convert it to tilemap coords
			var tile_data : TileData = tile_map.get_cell_tile_data(plant_layer, tile_mouse_pos)
			if tile_data:
				var can_harvest_tile = tile_data.get_custom_data(can_harvest)
				if can_harvest_tile:
					tile_map.set_cell(plant_layer, tile_mouse_pos, 4, Vector2i(0,0)) # basically removes tile
					# ^ throws an error due to tile not existing, dont worry it works fine
					current_harvest+=1
					rich_text_label.text = "Money: " + str(current_harvest)
		
			
func handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level):
	
	var source_id : int = 4
	
	tile_map.set_cell(plant_layer, tile_mouse_pos, source_id, atlas_coord)
	
	await get_tree().create_timer(1.0).timeout
	
	if level == final_seed_level:
		return
	else:
		var currentlvl = level
		var nextlvl = level+1
		var new_atlas : Vector2i = plant_0[nextlvl]
		handle_seed(tile_mouse_pos, nextlvl,new_atlas,3)
	
