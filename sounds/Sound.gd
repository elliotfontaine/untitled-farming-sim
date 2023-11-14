extends Node

# public vars
@export var _audioStreamPlayers : Array[AudioStream]
@export var can_play : bool = true

func play_sound(id):
	if can_play:
		var stream = AudioStreamPlayer.new()
		stream.stream = _audioStreamPlayers[id]
		
		add_child(stream)
		stream.play()

func stop_music():
	$".".stop()

func play_music():
	$".".play()
