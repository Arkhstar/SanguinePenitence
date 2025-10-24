extends AudioStreamPlayer

enum Song { SILENCE, FIGHT }

var _current : Vector3 = Vector3(Song.SILENCE, 0, 0)
var _cached_playback : Vector2 = Vector2(Song.SILENCE, 0)

func _get_playback_position() -> float:
	return get_playback_position() + AudioServer.get_time_since_last_mix()

func play_music(music : Song) -> void:
	if music == _current.x:
		return
	elif music in [ Song.FIGHT ]:
		_cached_playback = Vector2(_current.x, _get_playback_position())
	
	var audio_stream : AudioStreamOggVorbis = null
	var intro_seconds : float = 0.0
	
	if music == Song.FIGHT:
		audio_stream = preload("res://Audio/Music/Fight.ogg")
		intro_seconds = 5.857
	
	if not audio_stream == null:
		_current = Vector3(music, intro_seconds, audio_stream.get_length() - intro_seconds)
		stream = audio_stream
		if _cached_playback.x == music:
			play(_cached_playback.y)
			_cached_playback = Vector2(Song.SILENCE, 0)
		else:
			play(0)
	else:
		_current = Vector3(Song.SILENCE, 0, 0)
		stream = null
		stop()

func _process(_delta : float) -> void:
	if playing:
		if _get_playback_position() > _current.z * 0.75 + _current.y:
			seek(_current.z * 0.25 + _current.y)

func adjust_volume(new_volume : float, change_time : float) -> void:
	var t : Tween = create_tween()
	t.tween_property(self, "volume_linear", new_volume, change_time)
	t.play()
	await t.finished
