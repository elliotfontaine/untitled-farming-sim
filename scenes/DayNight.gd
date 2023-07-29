extends DirectionalLight2D

@onready var directional_light_2d = $"."
# -14.6 -116.4

var degrees : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	doDayNight() 

func doDayNight():
	await get_tree().create_timer(0.1).timeout
	directional_light_2d.rotate(deg_to_rad(degrees))
	if directional_light_2d.rotation_degrees > -14.6:
		directional_light_2d.enabled = false
	doDayNight()
