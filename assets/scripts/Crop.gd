class_name Crop extends Node2D

var plant

var tile_map_pos : Vector2i

var species_name : String
var family_name : String
var time_to_reach_maturity : int 

var buy_price : int = 10
var sell_price : int = 10

# This is for the sprite images, it gives an id that the array (plant) will use
var grow_state : int = 0
var max_grow_state : int = 4

# This is how much it takes to reach the next grow_state
var current_growth : float = 0
var required_growth_till_next_state : int = 100

# Nutrients

var nutrient_consumption_per_day : float = 0.1 # increase this based on how big the plant is

# Extra variables for things to be added later
var base_temp : float
var sick : bool

const PLANT_LAYER = 2

func is_mature():
	if grow_state == max_grow_state:
		return true
	else:
		return false
		
func can_grow():
	if grow_state < max_grow_state:
		return true
	else:
		return false
		
func grow(amount : int):
	if (!is_mature()):
		current_growth += amount
		if current_growth >= required_growth_till_next_state:
			current_growth = 0
			grow_state += 1
	
func get_growth_stage():
	return grow_state
