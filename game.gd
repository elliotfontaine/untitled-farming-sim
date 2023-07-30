extends Node

@onready var current_level = $TitleScreen

func _ready() -> void:
	current_level.level_changed.connect(switch_scene)
## Takes filepath to a Scene and replace the current level by a new one.
func switch_scene(level: String) -> void:
	var next_level = load(level)
	add_child(next_level.instantiate())
	current_level.queue_free()
	current_level = next_level
	
