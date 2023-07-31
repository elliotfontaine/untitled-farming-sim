extends TileMap

## The TileMap for our main level where the farm exist

# A better than these hardcoded enums should be found. Ok for now, but
# has to be automated to allow us to easily add new crops.

## For access by name to the different layers. Should be kept
## up to date if modifying the layers / their order in the inspector!
enum LAYERS {
	soil_data,
	dirt,
	ground,
	crops,
	obstacles
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
#	erase_cell(LAYERS.ground, Vector2i(11, 11))
	add_crop(Vector2i(14,10), CROP_ID.potato)
	add_crop(Vector2i(14,10), CROP_ID.carrot)
	add_crop(Vector2i(14,8), CROP_ID.potato)
#	add_crop(Vector2i(14,11), CROP_ID.carrot)
#	remove_crop(Vector2i(14,11))
#
#	add_crop(Vector2i(14,10), CROP_ID.carrot)
#	add_crop(Vector2i(14,11), CROP_ID.carrot)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Public methods
func add_crop(coords: Vector2i, crop_scene_id: int = 0):
	if can_place_crop(coords):
		set_cell(
			LAYERS.crops,
			coords,
			SOURCE_ID.crops_collection,
			Vector2i.ZERO,
			crop_scene_id
		)
	else:
		push_warning("Invalid tile for crop placement.")
	
func remove_crop(coords: Vector2i) -> void:
	erase_cell(LAYERS.crops, coords)


# private methods

## Check if a given cell at a certain layer has a tile in it. Return true if
## the cell is empty.
func is_cell_empty(layer: LAYERS, coords: Vector2i) -> bool:
	# get_cell_source_id returns -1 if a cell is empty
	return get_cell_source_id(layer, coords) == -1

## Check if given coordinates on the tilemap are a valid space to place a crop.
## Should have no obstacle, no crop already in place, and the "can_place"
## custom data for the tile on the ground layer.
func can_place_crop(coords: Vector2i) -> bool:
	if (
		!is_cell_empty(LAYERS.ground, coords)
		and is_cell_empty(LAYERS.obstacles, coords)
		and is_cell_empty(LAYERS.crops, coords)
	):
		var ground_cell_data = get_cell_tile_data(LAYERS.ground, coords)
		if ground_cell_data.get_custom_data("can_place"):
			return true
	return false
#	# Get the ID of the tile at the given coordinates from the ground layer
#	var ground_cell_data = get_cell_tile_data(LAYERS.ground, coords)
#	var obstacle_cell_data = get_cell_tile_data(LAYERS.obstacle, coords)
#	# if the ground exists, continue
#	if ground_cell_data:
#		# check if a tile has been marked with "can_place" -> true
#		if is_tile_located(LAYERS.crops, coords) and ground_cell_data.get_custom_data("can_place"):
#			return true
#	return false

# = is tile empty ?
func is_tile_located(layer : LAYERS, coords : Vector2i) -> bool:
	# Get a list of all the cells on a given layer
	var cells_array = get_used_cells(layer)
	# loop through the cells and check if it matches the coords inputed
	for x in range(cells_array.size()):
		if cells_array[x] == coords:
			return false
	return true
