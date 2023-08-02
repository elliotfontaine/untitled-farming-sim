extends TileMap

## The TileMap for our main level where the farm exist

# A better solution than these hardcoded enums should be found. Ok for now, but
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
	# etc if needed
}

## Once again, for the TileSetScenesCollectionSource IDs
enum CROPS {
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

# Private variables

## Scene Collection inside the tileset that holds the crops scenes.
var crops_collection_source: TileSetSource = tile_set.get_source(SOURCE_ID.crops_collection)
## Dictionary of node references to the crops existing on the TileMap.
var crop_scenes: Dictionary
# Note: Erasing elements while iterating over dictionaries is not supported and
# will result in unpredictable behavior. https://docs.godotengine.org/en/stable/classes/class_dictionary.html


# Called when the node enters the scene tree for the first time.
func _ready():
	print("start: ",self.get_children())
	add_crop(Vector2i(14,10), CROPS.potato)
	print("after add_crop: ", self.get_children())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Public methods

## Place a crop tile to the TileMap at the given coordinates. Will place beet by
## default if no id specified.
func add_crop(coords: Vector2i, crop_scene_id: int = 0) -> void:
	if can_place_crop(coords):
		set_cell(
			LAYERS.crops,
			coords,
			SOURCE_ID.crops_collection,
			Vector2i.ZERO,
			crop_scene_id
		)
		await self.child_entered_tree # Needed because set_cell with Scenes takes 1 process step
		crop_scenes[coords] = get_children()[-1] # Hopefully it works!
	else:
		push_warning("Invalid tile (%s) for crop placement." % coords)

## Removes a crop from the tilemap and the crop scene from the Tree.
func remove_crop(coords: Vector2i) -> void:
	if crop_scenes.has(coords):
		erase_cell(LAYERS.crops, coords)
		crop_scenes[coords].queue_free()
		crop_scenes.erase(coords)
	else:
		push_warning("No crop tile to delete at %s." % coords)

## Returns a reference to the crop Scene at the given coordinates if it exists,
## otherwise returns null. YOU SHOULD NOT USE THE REFERENCE TO DELETE THE SCENE
func get_crop(coords: Vector2i) -> Crop:
	if crop_scenes.has(coords):
		return crop_scenes[coords]
	else:
		return null


# Private methods

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

