extends Node2D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	## Should load data here if loading a save file
	pass # Replace with function body.

func _advance_calendar() -> void:
	if month in [MONTHS.MAY, MONTHS.AUGUST, MONTHS.NOVEMBER]:
		season +=1
	elif month == MONTHS.FEBRUARY:
		season = SEASONS.SPRING
	if month == MONTHS.DECEMBER:
		month = MONTHS.JANUARY
		year += 1
	else:
		month += 1
	
	
	
## Compute the growth for the plant at a given cell,
func _compute_growth(soil_data: SoilData) -> int:
	return 0

func _consume_nitrogen(cell: Vector2i) -> void:
	pass

func _gamble_sick(cell: Vector2i) -> void:
	pass

func _propagate_disease(cell: Vector2i) -> void:
	pass

