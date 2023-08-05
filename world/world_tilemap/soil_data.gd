class_name SoilData extends Node

## Just a data class that stores values about the soil (e.g. nutrients, etc.)
## Can be used on the TileMap through its associated scene (soil_data.tscn).

## Total nitrogen stock available in the soil for plants.
var total_nitrogen: int = 100:
	set(new_tn):
		total_nitrogen = 0 if new_tn < 0 else new_tn
## Number of months with no rotation of crops. Updated before calculating growth.
var total_month_unchanged: int = 0:
	set(new_mu):
		total_month_unchanged = 0 if new_mu < 0 else new_mu
## The crop that was on the tile at the end of the month.
## Is updated before calculating growth. A `null` value means no crop (bare field).
var month_crop: Crop = null:
	set(new_crop):
		if new_crop == null:
			total_month_unchanged = 0
		elif new_crop == month_crop:
			total_month_unchanged += 1
		else:
			total_month_unchanged = 1
		month_crop = new_crop

