class_name Global extends Node

enum SEASONS {
	SPRING = 1,
	SUMMER,
	FALL,
	WINTER
}

enum MONTHS {
	JANUARY = 1,
	FEBRUARY,
	MARCH,
	APRIL,
	MAY,
	JUNE,
	JULY,
	AUGUST,
	SEPTEMBER,
	OCTOBER,
	NOVEMBER,
	DECEMBER
}

enum WEATHER {
	CLEAR,
	RAIN,
	SNOW,
	FROST,
	DROUGHT
}

static func bernoulli(p: float = 0.5) -> bool:
	if p <= 0:
		return false
	elif p >= 1:
		return true
	else:
		return randf() < p
	
