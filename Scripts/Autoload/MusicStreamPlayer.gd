extends AudioStreamPlayer

enum Song { SILENCE, TITLE, BATTLE, BATTLE2, BATTLE3, TOWN, FOREST }

var _current : Vector3 = Vector3(Song.SILENCE, 0, 0)
var _cached_playback : Vector2 = Vector2(Song.SILENCE, 0)
var _t : Tween

func _get_playback_position() -> float:
	return get_playback_position() + AudioServer.get_time_since_last_mix()

func play_music(music : Song) -> void:
	if music == _current.x:
		return
	elif music in [ Song.BATTLE, Song.BATTLE2, Song.BATTLE3 ]:
		_cached_playback = Vector2(_current.x, _get_playback_position())
	
	var audio_stream : AudioStreamOggVorbis = null
	var intro_seconds : float = 0.0
	
	if music == Song.TITLE:
		audio_stream = preload("res://Audio/Music/Title.ogg")
		intro_seconds = 3.194
	elif music == Song.BATTLE:
		audio_stream = preload("res://Audio/Music/Battle/V1.ogg")
		intro_seconds = 5.324
	elif music == Song.BATTLE2:
		audio_stream = preload("res://Audio/Music/Battle/V2.ogg")
		intro_seconds = 2.928
	elif music == Song.BATTLE3:
		audio_stream = preload("res://Audio/Music/Battle/V3.ogg")
	elif music == Song.TOWN:
		audio_stream = preload("res://Audio/Music/Environmental/Town.ogg")
		intro_seconds = 3.194
	elif music == Song.FOREST:
		audio_stream = preload("res://Audio/Music/Environmental/Forest.ogg")
		intro_seconds = 2.662
	
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
	if _t:
		_t.kill()
	_t = create_tween()
	_t.tween_property(self, "volume_linear", new_volume, change_time)
	_t.play()
	await _t.finished

func get_playing() -> Song:
	return int(_current.x) as Song
