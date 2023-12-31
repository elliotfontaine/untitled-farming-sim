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

## Doc String
enum CROP_STATE {
	CROP,
	VEGETABLE
}

const deficient_texture := preload("res://crops/assets/info_bubbles/deficiency_bubble.png")
const sick_texture := preload("res://crops/assets/info_bubbles/sick_bubble.png")
const mature_texture := preload("res://crops/assets/info_bubbles/mature_bubble.png")


@export_group("Resource")
## If it is a crop (on land) or a fruit (inventory)
@export var state: CROP_STATE = CROP_STATE.CROP
## Number of Hframes in the Texture2D. Will be used
## to dynamically change the crop texture based on growth
@export var NUMBER_OF_STAGES: int = 4
## Crop Texture. An atlas of stages.
@export var crop_texture: CompressedTexture2D
## Vegetable Texture
@export var vegetable_texture: CompressedTexture2D


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
@export_range(0, 2000, 50, "or_greater") var max_growth: int = 1500
## DocString
@export_range(-100, 100, 5, "or_lower", "or_greater") var nitrogen_consumption: int = 0
## Baseline temperature in °C for the plant to grow. Its growth speed is
## proportionate to temperature minus this baseline. If temperature
## gets below the baseline, plant development will stop.
@export_range(0, 30, 1, "or_greater") var baseline_temperature: int = 5

@export_group("Pricing")
@export_range(0, 300, 5, "or_greater") var seed_cost: int = 0
@export_range(0, 300, 5, "or_greater") var selling_price: int = 0

# @export_group("Debug")
# Change the default spawn growth state. Should be 0
# @export_range(0, 200, 1) var growth: int = 0 : set = _set_growth

# Public variables
var growth: int = 0 : set = _set_growth
var sick: bool = false:
	set(s): _sick_bubble.visible = s; sick = s
var deficient: bool = false:
	set(def): _deficient_bubble.visible = def; deficient = def
	
# Private variables
var _sprite2d: Sprite2D
var _hbox_container: HBoxContainer
var _deficient_bubble: TextureRect
var _sick_bubble: TextureRect
var _mature_bubble: TextureRect

# @onready var _sprite2d: Sprite2D = self.get_node("Sprite2D")

# Built-in virtual methods
func _ready() -> void:
	# SET MAIN SPRITE
	_init_sprite()
	# SET INFO BUBBLES
	_init_info_bubbles()

func _process(_delta):
	if state == CROP_STATE.CROP:
		var mouse_is_inside = _hbox_container.get_global_rect().has_point(
			_hbox_container.get_global_mouse_position())
		if mouse_is_inside:
			_hbox_container.add_theme_constant_override(&"separation", -4)
		else:
			_hbox_container.add_theme_constant_override(&"separation", -8)
			
func _get_configuration_warnings():
	var warnings = []
	if species == "":
		warnings.append("Please set `species` to a non-empty value.")
	# Returning an empty array means "no warning".
	return warnings


# Public methods

## DocString
func is_mature() -> bool:
	return growth == max_growth
		
func can_grow() -> bool:
	return !is_mature()

## DocString
func grow(amount : int) -> void:
	if amount < 0:
		push_warning("You can't send a negative growth to a Crop. " + self.to_string())
		return
	_set_growth(growth + amount)

##DocString
func harvest() -> void:
	if is_mature():
		# drop fruit items
		pass # TO IMPLEMENT
	else:
		# drop seed
		pass # TO IMPLEMENT
	queue_free()


# Private methods

## DocString
func _init_sprite() -> void:
	_sprite2d = Sprite2D.new() # Create a new Sprite2D.
	add_child(_sprite2d) # Add it as a child of this node.
	if state == CROP_STATE.CROP:
		_sprite2d.texture = crop_texture
		_sprite2d.hframes = NUMBER_OF_STAGES
	elif state == CROP_STATE.VEGETABLE:
		_sprite2d.texture = vegetable_texture

## DocString
func _init_info_bubbles() -> void:
	# Make an HBoxContainer that will arrange and center bubbles when
	# they are set to visible
	_hbox_container = HBoxContainer.new()
	_hbox_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_hbox_container.size = Vector2i(22, 13)
	_hbox_container.position = Vector2i(-12, -18)
	_hbox_container.add_theme_constant_override(&"separation", -8)
	_hbox_container.z_index = 2
	add_child(_hbox_container)
	# Create 3 types of info bubbles and add them to the container
	_deficient_bubble = TextureRect.new()
	_sick_bubble = TextureRect.new()
	_mature_bubble = TextureRect.new()
	var bubbles := [_deficient_bubble, _sick_bubble, _mature_bubble]
	var textures := [deficient_texture, sick_texture, mature_texture]
	var tooltips := ["Deficient", "Sick", "Mature"]
	for i in range(bubbles.size()):
		bubbles[i].texture = textures[i]
		bubbles[i].visible = false
		bubbles[i].tooltip_text = tooltips[i]
		_hbox_container.add_child(bubbles[i])
	
## DocString
func _set_growth(new_growth: int) -> void:
	growth = new_growth if new_growth <= max_growth else max_growth
	if is_mature():
		_mature_bubble.visible = true
		_sprite2d.frame = NUMBER_OF_STAGES - 1
		# Frame is zero-indexed, starts at 0 and ends at 3 if Hframes=4
	else:
		_mature_bubble.visible = false
		@warning_ignore("integer_division")
		_sprite2d.frame = (growth * (NUMBER_OF_STAGES-1)) / max_growth
		# Mathematic sorcery that should always give a number between
		# 0 and the max Frame index for any number bewteen 0 and
		# max_growth. We could even ditch the "if is_mature()"
		# condition above.
