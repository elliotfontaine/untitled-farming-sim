extends Node

# public vars
@export var _audioStreamPlayers : Array[AudioStream]

func play_sound(id):
	var stream = AudioStreamPlayer.new()
	stream.stream = _audioStreamPlayers[id]
	
	add_child(stream)
	stream.play()
	
