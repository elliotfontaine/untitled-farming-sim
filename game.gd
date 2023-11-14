extends Node

@onready var current_level = $TitleScreen

func _ready() -> void:
	randomize()
	current_level.level_changed.connect(switch_scene)
## Takes filepath to a Scene and replace the current level by a new one.

func switch_scene(level: PackedScene) -> void:
	var next_level = level.instantiate()
	current_level.queue_free()
	current_level = next_level
	add_child(current_level)
	current_level.level_changed.connect(switch_scene)
	
