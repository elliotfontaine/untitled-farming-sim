@tool
class_name Crop extends Node2D

## A crop to be placed in the world. Grows in different visual stages
## and can be sowed and harvested.

## Plant families enum
enum FAMILIES {
	FABACEAE,
	POACEAE,
	ASTERACEAE,
	BRASSICACEAE,
	APIACEAE,
	AMARANTHACEAE,
	CUCURBITACEAE,
	SOLANACEAE,
	AMARYLLIDACEAE
}

@export_group("Resource")
## Number of Hframes in the Texture2D. Will be used
## to dynamically change the texture based on growth
@export var NUMBER_OF_STAGES: int = 4
## Texture atlas
@export var texture: CompressedTexture2D

@export_group("Plant")
## Name of the crop. Used as an identifier.
@export var species: String = "NA":
	set(p_species):
			if p_species != species:
				species = p_species
				update_configuration_warnings()
## Plant family. Influences disease outbreak.
@export var family: FAMILIES
## Maximum growth in Growing degree-days
@export var max_growth: int = 200
## Baseline temperature for the plant to grow. Its growth speed is
## proportionate to temperature minus this baseline. If temperature
## gets below the baseline, plant development will stop.
@export var baseline_temperature: int = 5

@export_group("Pricing")
@export var selling_price: int = 0:
	set(p_price):
		if p_price != selling_price:
			selling_price = p_price
			update_configuration_warnings()
@export var seed_cost: int = 0:
	set(p_cost):
		if p_cost != seed_cost:
			seed_cost = p_cost
			update_configuration_warnings()

# Public variables
var growth: int = 0 : set = _set_growth
var growth_stage: int = 0
var sick: bool = false
var sprite2d: Sprite2D

# Built-in virtual methods
func _ready() -> void:
	sprite2d = Sprite2D.new() # Create a new Sprite2D.
	add_child(sprite2d) # Add it as a child of this node.
	sprite2d.texture = texture
	sprite2d.hframes = NUMBER_OF_STAGES

func _get_configuration_warnings():
	var warnings = []
	if species == "":
		warnings.append("Please set `species` to a non-empty value.")
	if seed_cost < 0 or selling_price < 0:
		warnings.append("Pricing values should be positive.")
	# Returning an empty array means "no warning".
	return warnings

# Public methods
func is_mature() -> bool:
	return growth == max_growth
		
func can_grow() -> bool:
	return !is_mature()

func grow(amount : int) -> void:
	if amount < 0:
		push_warning("You can't send a negative growth to a Crop.")
		return
	_set_growth(growth + amount)

func harvest() -> void:
	if growth == max_growth:
		# drop fruit items
		pass # TO IMPLEMENT
	else:
		# drop seed
		pass # TO IMPLEMENT
	queue_free()

# Private methods
func _set_growth(new_growth: int) -> void:
	growth = new_growth if new_growth <= max_growth else max_growth
	if is_mature():
		sprite2d.frame = NUMBER_OF_STAGES - 1
		# Frame is zero-indexed, starts at 0 and ends at 3 if Hframes=4
	else:
		sprite2d.frame = (growth * NUMBER_OF_STAGES-1) / max_growth
		# Mathematic sorcery that should always give a number between
		# 0 and the max Frame index for any number bewteen 0 and
		# max_growth. We could even ditch the "if is_mature()"
		# condition above.
