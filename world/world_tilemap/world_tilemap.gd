extends TileMap

## The TileMap for our main level where the farm exist

## For access by name to the different layers. Should be kept
## up to date if modifying the layers / their order in the inspector!
enum LAYERS {
	soil_data,
	dirt,
	ground,
	crops,
	obstacles,
	tile_selector
}

@export var tile_selector_source_id: int = 5

# Public variables

## Dictionary of node references to the crops existing on the TileMap.
var crop_instances: Dictionary
# Note: Erasing elements while iterating over dictionaries is not supported and
# will result in unpredictable behavior. https://docs.godotengine.org/en/stable/classes/class_dictionary.html

# Private variables

## Cursor position
var _selector_pos : Vector2i = Vector2i(-100, -100)

@onready var crop_scenes: ResourcePreloader = get_node("/root/CropsPreloader")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_crop(Vector2i(14,10), "potato")
	pass # Replace with function body.

# Public methods

## Place a crop tile to the TileMap at the given coordinates. Will place beet by
## default if no id specified.
func add_crop(coords: Vector2i, crop_name: StringName) -> void:
	if not crop_scenes.has_resource(crop_name):
		push_warning("Invalid name ('%s') for the crop. \
			Does not exist in the crops Autoload." % crop_name)
		return
	elif not _can_place_crop(coords):
		# push_warning("Invalid tile (%s) for crop placement." % coords)
		return
	else:
		# Add the crop to the scene as a child of the TileMap
		var new_crop: Crop = CropsPreloader.get_resource(crop_name).instantiate()
		new_crop.position = map_to_local(coords)
		add_child(new_crop)
		# Add the crop to the dictionary for presence lookup.
		crop_instances[coords] = new_crop
		#print_debug(crop_instances)
		

## Removes a crop from the tilemap and the crop scene from the Tree.
func remove_crop(coords: Vector2i) -> void:
	if crop_instances.has(coords):
		# Remove the crop from the ScenesTree
		crop_instances[coords].queue_free()
		# And then remove it from the dictionary
		crop_instances.erase(coords)
		#print_debug(crop_instances)
	else:
		pass
		# push_warning("No crop tile to delete at %s." % coords)

## Returns a reference to the crop Scene at the given coordinates if it exists,
## otherwise returns null. YOU SHOULD NOT USE THE REFERENCE TO DELETE THE SCENE
func get_crop(coords: Vector2i) -> Crop:
	if crop_instances.has(coords):
		return crop_instances[coords]
	else:
		return null

## Move the tile selector (square cursor) to the given coordinate.
func set_tile_selector(coords: Vector2i) -> void:
	if coords == _selector_pos:
		return
	elif _can_place_crop(coords):
		set_cell(LAYERS.tile_selector, coords, tile_selector_source_id, Vector2i(0,0))
		erase_cell(LAYERS.tile_selector, _selector_pos)
		_selector_pos = coords
	else:
		set_cell(LAYERS.tile_selector, coords, tile_selector_source_id, Vector2i(0,1))
		erase_cell(LAYERS.tile_selector, _selector_pos)
		_selector_pos = coords
#		erase_cell(LAYERS.tile_selector, _selector_pos)
#		_selector_pos = Vector2i(-100, -100)
		
# Private methods

## Check if a given cell at a certain layer has a tile in it. Return true if
## the cell is empty. 
func _is_cell_empty(layer: LAYERS, coords: Vector2i) -> bool:
	if layer == LAYERS.crops:
		return !crop_instances.has(coords)
	else:
		return get_cell_tile_data(layer, coords) == null

## Check if given coordinates on the tilemap are a valid space to place a crop.
## Should have no obstacle, no crop already in place, and the "can_place"
## custom data for the tile on the ground layer.
func _can_place_crop(coords: Vector2i) -> bool:
	if (
		_is_cell_empty(LAYERS.obstacles, coords)
		and _is_cell_empty(LAYERS.crops, coords)
	):
		var ground_cell_data = get_cell_tile_data(LAYERS.ground, coords)
		if ground_cell_data and ground_cell_data.get_custom_data("can_place"):
			return true
	return false
