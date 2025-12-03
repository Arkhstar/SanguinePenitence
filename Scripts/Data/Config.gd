class_name Config
extends Resource

static var battle_pulse_effect : bool = true
static var battle_metronome_effect : bool = false
static var text_speed : int = 2

static var window_mode : int = 0 :
	set(v):
		window_mode = v
		if v < 0 or window_mode < 0:
			return
		if window_mode < 2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, window_mode == 1)
			Main.i.get_window().size = Vector2i(640 * (resolution + 1), 360 * (resolution + 1))
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
static var resolution : int = 0 :
	set(v):
		if v < 0 or resolution < 0:
			return
		if resolution != v:
			Main.i.get_window().position -= Vector2i(320 * (v - resolution), 180 * (v - resolution))
		resolution = v
		Main.i.get_window().size = Vector2i(640 * (resolution + 1), 360 * (resolution + 1))

static func load_config() -> void:
	var f : FileAccess = FileAccess.open(_get_path(), FileAccess.READ)
	if FileAccess.get_open_error() == OK:
		var contents : String = f.get_as_text()
		var json : JSON = JSON.new()
		if json.parse(contents) == OK:
			var data : Variant = json.data
			if data is Dictionary:
				battle_pulse_effect = data["plse"]
				battle_metronome_effect = data["mtrm"]
				text_speed = data["txsp"]
				window_mode = data["wndw"]
				resolution = data["rltn"]
				AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), data["mstv"])
				AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), data["musv"])
				AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), data["sfxv"])
				FlowerwallCRT.set_ca(data["cabr"])

static func save_config() -> void:
	var f : FileAccess = FileAccess.open(_get_path(), FileAccess.WRITE)
	if FileAccess.get_open_error() == OK:
		var dict : Dictionary = {
			"plse" : battle_pulse_effect,
			"mtrm" : battle_metronome_effect,
			"txsp" : text_speed,
			"wndw" : window_mode,
			"rltn" : resolution,
			"mstv" : AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")),
			"musv" : AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music")),
			"sfxv" : AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX")),
			"cabr" : FlowerwallCRT.get_ca()
		}
		f.store_string(JSON.stringify(dict))

static func _get_path() -> String:
	return OS.get_user_data_dir() + "/game.cfg"
