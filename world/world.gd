extends Node2D

signal level_changed(level_name)

# Public Variables
const SEASONS := Global.SEASONS
const MONTHS := Global.MONTHS
const WEATHER := Global.WEATHER
const MED_TEMP: Dictionary = {
	MONTHS.JANUARY: 4,
	MONTHS.FEBRUARY: 4,
	MONTHS.MARCH: 7,
	MONTHS.APRIL: 9,
	MONTHS.MAY: 13,
	MONTHS.JUNE: 16,
	MONTHS.JULY: 18,
	MONTHS.AUGUST: 18,
	MONTHS.SEPTEMBER: 15,
	MONTHS.OCTOBER: 11,
	MONTHS.NOVEMBER: 7,
	MONTHS.DECEMBER: 4
}
const QTY_REPLENISH_NITROGEN: int = 20
const P_GEOM_DISTRIB: float = 0.005
const P_PROPAGATION: float = 0.50
## Should be written/read by the save system if implemented.
#var world_data: Dictionary = {
#	"year": 1,
#	"season": SEASONS.SPRING,
#	"month": MONTHS.MARCH,
#	"temperature": 12,
#	"weather" : WEATHER.CLEAR
#}
var year: int = 1
var season := SEASONS.SPRING
var month := MONTHS.MARCH
var temperature: int = MED_TEMP[MONTHS.MARCH]
var weather := WEATHER.CLEAR

# Onready variables
## DocString
@onready var tilemap: TileMap = $WorldTileMap
@onready var player: Node2D = $ClickingPlayerCharacter
@onready var transition_screen: Control = $GeneralUI/MonthTransition
@onready var hud: CanvasLayer = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	## Should load data here if loading a save file
	pass # Replace with function body.

func time_skip() -> void:
	
	hud.hide()
	transition_screen.animation_player.play("fade_in_out")
	#get_tree().paused = true
	
	# Crops and soil changes for the month
	for coords in tilemap.soildata_instances:
		var soildata: SoilData = tilemap.soildata_instances[coords]
		# If the field cell has a crop
		if tilemap.crop_instances.has(coords):
			var crop: Crop = tilemap.crop_instances[coords]
			crop.grow(_compute_growth(crop, soildata))
			soildata.total_nitrogen -= crop.nitrogen_consumption
			soildata.current_crop = crop
			#_propagate_disease()
			if crop.sick == false:
				crop.sick = _gamble_sick(soildata)
				print(crop.sick)
			else:
				_propagate_disease(coords, crop.family)
		# If the field is bare, during fallow for exemple
		else:
			soildata.total_nitrogen += QTY_REPLENISH_NITROGEN
			soildata.current_crop = null
	# Money and game over handling
	pass
	# Changing to new month
	_advance_calendar()
	temperature = _random_temperature(month)
	
	await transition_screen.exited
	hud.show()

func _advance_calendar() -> void:
	# Seasons
	if month in [MONTHS.MAY, MONTHS.AUGUST, MONTHS.NOVEMBER]:
		@warning_ignore("int_as_enum_without_cast")
		season += 1
	elif month == MONTHS.FEBRUARY:
		season = SEASONS.SPRING
	# Months & Year
	if month == MONTHS.DECEMBER:
		month = MONTHS.JANUARY
		year += 1
	else:
		@warning_ignore("int_as_enum_without_cast")
		month += 1
	
func _money_costs() -> void:
	pass
	
## Compute the growth for the plant given crop and soil data
func _compute_growth(crop: Crop, soildata: SoilData) -> int:
	# Parameters:
	# - Current world temperature (before change)
	# every degree above baseline = 1 GDD, multiplied by 30 days
	# https://en.wikipedia.org/wiki/Growing_degree-day
	# - Current nitrogen level (if > 3*consumption: 1,
	# if bewteen 1c et 3c: 0.8, if below 1c: 0.3
	# THIS TIERING IS NOT BASED ON REAL CONCEPT/DATA
	# - is the plant sick (0.8 factor)
	var days := 30 #90 IF SEASON
	var delta_T := temperature - crop.baseline_temperature
	var sick_factor := 0.8 if crop.sick else 1.0
	var NO3_ratio := float(soildata.total_nitrogen) / crop.nitrogen_consumption
	var NO3_factor: float
	if NO3_ratio >= 3 or NO3_ratio < 0: # negative is consumption also is
		NO3_factor = 1.0
	elif 1 <= NO3_ratio and NO3_ratio < 3:
		NO3_factor = 0.8
	else:
		NO3_factor = 0.3
	# print(days, " ", delta_T, " ", sick_factor, " ", NO3_factor)
	var growth: int = round(days*delta_T*sick_factor*NO3_factor)
	return growth

## Pick a random temperature from a certain month, based on the medium
## temperature for the month and a variation that follows an uniform law.
func _random_temperature(current_month: MONTHS) -> int:
	var med_temp: int = MED_TEMP[current_month]
	return med_temp + randi_range(-2, 2)

## Uses the cumulative distribution function of a geometric distribution.
## With k the `total_month_unchanged` & p probability of getting sick 1st month:
## P("getting sick") = 1 - (1-p)**k
func _gamble_sick(soildata: SoilData) -> bool:
	var proba := 1 - pow((1-P_GEOM_DISTRIB), soildata.total_month_unchanged)
	return randf() < proba

func _propagate_disease(cell: Vector2i, family: Crop.FAMILIES) -> void:
	var neighbors := tilemap.get_surrounding_cells(cell)
	for neighbor_cell in neighbors:
		if not tilemap.crop_instances.has(neighbor_cell):
			break
		var neighbor_crop: Crop = tilemap.crop_instances[neighbor_cell]
		if not neighbor_crop.sick and neighbor_crop.family == family:
			neighbor_crop.sick = Global.bernoulli(P_PROPAGATION)
		



