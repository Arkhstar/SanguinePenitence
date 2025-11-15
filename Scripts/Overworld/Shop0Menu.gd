class_name Shop0Menu
extends NinePatchRect

signal exit

var ignore_input : bool = true

@onready var options : Array[Label] = [
	$Strength,
	$Defense,
	$Sharpen,
	$Buy,
	$Exit
]

@onready var cursor : ColorRect = $Highlight
@onready var cursor_indicator : TextureRect = $Highlight/Cursor
var option : int = 0

var cost : int = 0

@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up"):
		option = (option + 4) % 5
		nav_sfx.play()
	if Input.is_action_just_pressed("menu_right") or Input.is_action_just_pressed("menu_down"):
		option = (option + 1) % 5
		nav_sfx.play()
	if option < 2:
		cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
		cursor.size.x = 172.0
	else:
		cursor.global_position = options[option].global_position + Vector2(49.0, -1.0)
		cursor.size.x = 212.0
	cursor_indicator.position.x = cursor.size.x - 2
	if Input.is_action_just_pressed("menu_select"):
		if option < 2:
			select_sfx.play()
			ignore_input = true
			cursor.global_position = options[option].option.global_position - Vector2(1.0, 1.0)
			cursor.size.x = 112
			cursor_indicator.hide()
			await RenderingServer.frame_post_draw
			await RenderingServer.frame_post_draw
			options[option].selected = true
		elif option == 2:
			var sharpen_cost : int = _get_sharpen_cost()
			if SaveData.obols < sharpen_cost:
				fail_sfx.play()
			else:
				select_sfx.play()
				SaveData.obols -= sharpen_cost
				SaveData.hunter_unit.sharpness += sharpen_cost if sharpen_cost > 0 else -SaveData.hunter_unit.sharpness
				_update_sharpen_label()
		elif option == 3:
			select_sfx.play()
			SaveData.hunter_unit.strength += randi_range(options[0].o, 2 * options[0].o) 
			SaveData.hunter_unit.defense += randi_range(options[1].o, 2 * options[1].o)
			for i : int in 2:
				SaveData.obols -= options[i].o * options[i].cost
				options[i].cp = 0
				options[i].o = 0
				options[i].update_option(0)
			cost = 0
		else:
			select_sfx.play()
			ignore_input = true
			exit.emit()
		return
	if Input.is_action_just_pressed("menu_cancel"):
		ignore_input = true
		exit.emit()

func return_from_setting() -> void:
	cursor.position = options[option].position - Vector2(1.0, 1.0)
	cursor.size.x = 172.0
	cost = 0
	for i : int in 2:
		cost += options[i].o * options[i].cost
	for i : int in 2:
		options[i].cp = cost - options[i].o * options[i].cost
		options[i].update_option(options[i].o)
	ignore_input = false
	cursor_indicator.show()

func reset() -> void:
	option = 0
	cost = 0
	cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
	cursor.size.x = 172.0
	cursor_indicator.show()
	for i : int in 2:
		options[i].reset(0)
	_update_sharpen_label()

func _ready() -> void:
	options[0].init("STRENGTHEN WEAPON", 100, cost)
	options[1].init("STRENGTHEN ARMOR", 150, cost)
	
	for i : int in 2:
		options[i].exit.connect(return_from_setting)
	
	reset()

func open() -> void:
	reset()
	show()
	ignore_input = false

func close() -> void:
	ignore_input = true
	hide()

func _update_sharpen_label() -> void:
	var sharpen_cost : int = _get_sharpen_cost()
	options[2].text = "SHARPEN WEAPON : %s" % ["FREE" if sharpen_cost == 0 else str(sharpen_cost)]
	if SaveData.obols < sharpen_cost:
		options[2].add_theme_color_override("font_color", Color("#0f1216"))

func _get_sharpen_cost() -> int:
	var hunter_sharpness : int = SaveData.hunter_unit.get_sharpness_rank()
	return 0 if hunter_sharpness == 0x46 else (50 if hunter_sharpness == 0x44 else (100 if hunter_sharpness == 0x43 else (175 if hunter_sharpness == 0x42 else (250 if hunter_sharpness == 0x41 else 500))))
