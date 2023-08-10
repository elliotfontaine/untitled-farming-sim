class_name SoilData extends Node2D

## Just a data class that stores values about the soil (e.g. nutrients, etc.)
## Can be used on the TileMap through its associated scene (soil_data.tscn).
## Does NOT have any real method, only customized setters.

## Total nitrogen stock available in the soil for plants.
var total_nitrogen: int = 100:
	set(new_tn):
		total_nitrogen = 0 if new_tn < 0 else new_tn
## Number of months with no rotation of crops. Changed when current_crop is changed.
var total_month_unchanged: int = 0:
	set(new_mu):
		total_month_unchanged = 0 if new_mu < 0 else new_mu
## The crop that was on the tile at the end of the month.
## Is updated before calculating growth. A `null` value means no crop (bare field).
var current_crop: Crop = null:
	set(new_crop):
		if new_crop == null:
			total_month_unchanged = 0
		elif new_crop.FAMILIES == current_crop.FAMILIES:
			total_month_unchanged += 1
		else:
			total_month_unchanged = 1
		current_crop = new_crop

