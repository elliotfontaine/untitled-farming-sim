extends TileMap

## The TileMap for our main level where the farm exist

# A better than these hardcoded enums should be found. Ok for now, but
# has to be automated to allow us to easily add new crops.

## For access by name to the different layers. Should be kept
## up do date if modifying the layers / their order in the inspector!
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
	erase_cell(LAYERS.ground_layer, Vector2i(11, 11))
	add_crop(Vector2i(14,10), CROP_ID.potato)
	
	add_crop(Vector2i(14,11), CROP_ID.carrot)
	remove_crop(Vector2i(14,11))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Public functions
func add_crop(coords: Vector2i, crop_scene_id: int = 0):
	set_cell(
		LAYERS.crops_layer,
		coords,
		SOURCE_ID.crops_collection,
		Vector2i(0,0),
		crop_scene_id
	)
	
func remove_crop(coords: Vector2i) -> void:
	erase_cell(LAYERS.crops_layer, coords)
	

