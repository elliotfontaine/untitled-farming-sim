extends Crop

var crop = Crop.new()
@onready var sprite_2d = $"."

func _ready():
	crop.plant = [preload("res://assets/images/objects/tdfarmobj_plant_0_0.png"), preload("res://assets/images/objects/tdfarmobj_plant_0_1.png"), preload("res://assets/images/objects/tdfarmobj_plant_0_2.png"), preload("res://assets/images/objects/tdfarmobj_plant_0_3.png")]
	crop.species_name = "Wheat"
	crop.time_to_reach_maturity = 100
	crop.buy_price = 10
	crop.sell_price = 20
	crop.max_grow_state = 3
	crop.base_temp = 50
	do_grow_cycle()

# Do whatever you need to do to the crop to make it grow
func do_grow_cycle():
	# change the value below which is affected by things like temperature and nutrients
	crop.grow(10)
	
	sprite_2d.texture = crop.plant[crop.get_growth_stage()]
	
	print(crop.current_growth)
	
	# Recursion (world time master should take control of this)
	await get_tree().create_timer(1.0).timeout
	do_grow_cycle()
