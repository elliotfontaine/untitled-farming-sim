extends Sprite2D

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

func do_grow_cycle():
	crop.increase_growth(0.1)
	sprite_2d.texture = crop.plant[crop.get_growth_stage()]
