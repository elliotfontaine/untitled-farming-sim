class_name Crop

var atlasID : int
var atlas_coords : Vector2i # we need this because the atlases positions are all different

var tile_map_pos : Vector2i

var species_name : String
var family_name : String
var time_to_reach_maturity : int 

var buy_price : int
var sell_price : int

var grow_state : int
var max_grow_state : int

var sick : bool

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
		grow_state += amount
	
func get_growth_stage():
	return grow_state
	
