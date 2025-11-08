class_name SettingsMenu
extends CanvasLayer

var ignore_input : bool = true

static var i : SettingsMenu = null

@onready var options : Array[SettingsOption] = [
	$Panel/VolumeMaster,
	$Panel/VolumeMusic,
	$Panel/VolumeSFX,
	$Panel/WindowMode,
	$Panel/Resolution,
	$Panel/TextSpeed,
	$Panel/PulseEffect,
	$Panel/Metronome,
	$Panel/Chromatic
]

@onready var cursor : ColorRect = $Panel/Highlight
@onready var cursor_indicator : TextureRect = $Panel/Highlight/Cursor
var option : int = 0

@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up"):
		option = (option + 8) % 9
		nav_sfx.play()
	if Input.is_action_just_pressed("menu_right") or Input.is_action_just_pressed("menu_down"):
		option = (option + 1) % 9
		nav_sfx.play()
	cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
	if Input.is_action_just_pressed("menu_select"):
		select_sfx.play()
		ignore_input = true
		cursor.global_position = options[option].option.global_position - Vector2(1.0, 1.0)
		cursor_indicator.hide()
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		options[option].selected = true
		return
	if Input.is_action_just_pressed("menu_cancel"):
		ignore_input = true
		Main.i.close_settings()

func return_from_setting() -> void:
	ignore_input = false
	cursor.position = options[option].position - Vector2(1.0, 1.0)
	cursor_indicator.show()

func reset() -> void:
	option = 0
	cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
	cursor_indicator.show()
	for settings_option : SettingsOption in options:
		settings_option.update_option()

func _ready() -> void:
	options[0].init(
		"MASTER VOL",
		AudioServer.get_bus_volume_linear.bind(AudioServer.get_bus_index("Master")),
		func(vol : float) -> void: AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), vol),
		func(vol : float) -> String: return "%3.f" % snappedf(vol * 100, 1),
		0.0, 1.0,
		func(vol : float) -> float: return snappedf(minf(vol + 0.05, 1.0), 0.05),
		func(vol : float) -> float: return snappedf(maxf(vol - 0.05, 0.0), 0.05)
	)
	options[1].init(
		"MUSIC VOL",
		AudioServer.get_bus_volume_linear.bind(AudioServer.get_bus_index("Music")),
		func(vol : float) -> void: AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), vol),
		func(vol : float) -> String: return "%3.f" % snappedf(vol * 100, 1),
		0.0, 1.0,
		func(vol : float) -> float: return snappedf(minf(vol + 0.05, 1.0), 0.05),
		func(vol : float) -> float: return snappedf(maxf(vol - 0.05, 0.0), 0.05)
	)
	options[2].init(
		"SFX VOL",
		AudioServer.get_bus_volume_linear.bind(AudioServer.get_bus_index("SFX")),
		func(vol : float) -> void: AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), vol),
		func(vol : float) -> String: return "%3.f" % snappedf(vol * 100, 1),
		0.0, 1.0,
		func(vol : float) -> float: return snappedf(minf(vol + 0.05, 1.0), 0.05),
		func(vol : float) -> float: return snappedf(maxf(vol - 0.05, 0.0), 0.05)
	)
	
	options[3].init(
		"WINDOW MODE",
		func() -> int: return Config.window_mode,
		func(mode : int) -> void: Config.window_mode = mode,
		func(mode : int) -> String: return ["WINDOWED", "BORDERLESS", "FULLSCREEN"][mode],
		0, 2,
		func(mode : int) -> int: return mini(mode + 1, 2),
		func(mode : int) -> int: return maxi(mode - 1, 0),
		false
	)
	options[4].init(
		"RESOLUTION",
		func() -> int: return Config.resolution,
		func(res : int) -> void: Config.resolution = res,
		func(res : int) -> String: return ["640 X 360", "1280 X 720", "1920 X 1080", "2560 X 1440"][res],
		0, 3,
		func(res : int) -> int: return mini(res + 1, 3),
		func(res : int) -> int: return maxf(res - 1, 0),
		false
	)
	
	options[5].init(
		"TEXT SPEED",
		func() -> int: return Config.text_speed,
		func(speed : int) -> void: Config.text_speed = speed,
		func(speed : int) -> String: return ["VERY SLOW", "SLOW", "NORMAL", "FAST", "VERY FAST"][speed],
		0, 4,
		func(speed : int) -> int: return mini(speed + 1, 4),
		func(speed : int) -> int: return maxf(speed - 1, 0)
	)
	
	options[6].init(
		"PULSING",
		func() -> bool: return Config.battle_pulse_effect,
		func(boolean : bool) -> void: Config.battle_pulse_effect = boolean,
		func(boolean : bool) -> String: return "ENABLED" if boolean else "DISABLED",
		false, true,
		func(_boolean : bool) -> bool: return true,
		func(_boolean : bool) -> bool: return false
	)
	options[7].init(
		"METRONOME",
		func() -> bool: return Config.battle_metronome_effect,
		func(boolean : bool) -> void: Config.battle_metronome_effect = boolean,
		func(boolean : bool) -> String: return "ENABLED" if boolean else "DISABLED",
		false, true,
		func(_boolean : bool) -> bool: return true,
		func(_boolean : bool) -> bool: return false
	)
	options[8].init(
		"COL. ABERR.",
		func() -> bool: return FlowerwallCRT.get_ca(),
		func(boolean : bool) -> void: FlowerwallCRT.set_ca(boolean),
		func(boolean : bool) -> String: return "ENABLED" if boolean else "DISABLED",
		false, true,
		func(_boolean : bool) -> bool: return true,
		func(_boolean : bool) -> bool: return false
	)
	
	for settings_option : SettingsOption in options:
		settings_option.exit.connect(return_from_setting)
	
	reset()
