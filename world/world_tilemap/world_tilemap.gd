extends TileMap

## The TileMap for our main level where the farm exist

# A better than these hardcoded enums should be found. Ok for now, but
# has to be automated to allow us to easily add new crops.

## For access by name to the different layers. Should be kept
## up to date if modifying the layers / their order in the inspector!
enum LAYERS {
	soil_data_layers,
	dirt_layer,
	ground_layer,
	crops_layer,
	obstacle_layer
}

## Same thing, keep ut to date with sources in the tileset
enum SOURCE_ID {
	grass,
	rocky_path,
	fence,
	wet_dirt,
	dirt,
	crops_collection,
	blue_house = 16,
	red_house = 17
}

## Once again, for the TileSetScenesCollectionSource 
enum CROP_ID {
	beet,
	carrot,
	cauliflower,
	french_beans,
	onion,
	potato,
	pumpkin,
	tomato,
	turnip,
	wheat
}

# public attributes
var crops_collection_source = tile_set.get_source(SOURCE_ID.crops_collection)

# Called when the node enters the scene tree for the first time.
func _ready():
	# this is just to debug / test script for now
#	erase_cell(LAYERS.ground_layer, Vector2i(11, 11))
	add_crop(Vector2i(14,10), CROP_ID.potato)
	add_crop(Vector2i(14,10), CROP_ID.carrot)
	
#	add_crop(Vector2i(14,11), CROP_ID.carrot)
#	remove_crop(Vector2i(14,11))
#
#	add_crop(Vector2i(14,10), CROP_ID.carrot)
#	add_crop(Vector2i(14,11), CROP_ID.carrot)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Public functions
func add_crop(coords: Vector2i, crop_scene_id: int = 0):
	if can_place(coords):
		set_cell(
			LAYERS.crops_layer,
			coords,
			SOURCE_ID.crops_collection,
			Vector2i(0,0),
			crop_scene_id
		)
	
func remove_crop(coords: Vector2i) -> void:
	erase_cell(LAYERS.crops_layer, coords)
	
func can_place(coords: Vector2i) -> bool:
	
	# Get the ID of the tile at the given coordinates from the ground layer
	var ground_tiles = get_cell_tile_data(LAYERS.ground_layer, coords)
	# if the ground exists, continue
	if ground_tiles:
		# check if a tile has been marked with "can_place" -> true
		if is_tile_located(LAYERS.crops_layer, coords) and ground_tiles.get_custom_data("can_place"):
			return true
	return false

func is_tile_located(layer : LAYERS, coords : Vector2i) -> bool:
	# Get a list of all the cells on a given layer
	var cells_array = get_used_cells(layer)
	# loop through the cells and check if it matches the coords inputed
	for x in range(cells_array.size()):
		if cells_array[x] == coords:
			return false
	return true
