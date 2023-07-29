class_name Crop extends Node2D

var plant

var tile_map_pos : Vector2i

var species_name : String
var family_name : String
var time_to_reach_maturity : int 

var buy_price : int
var sell_price : int

var grow_state : int = 0
var max_grow_state : int

var current_growth : float = 0
var required_growth_till_next_state : int

var base_temp : float

var nutrient_consumption_per_day : float

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
		
func increase_growth(amount : int):
	if (!is_mature()):
		current_growth += amount
		if current_growth >= required_growth_till_next_state:
			grow_state += 1
	
func get_growth_stage():
	return grow_state
