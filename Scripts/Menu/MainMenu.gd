class_name MainMenu
extends Node

var ignore_input : bool = true

@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

@onready var pointer : TextureRect = $Cursor
@onready var options : Array[Label] = [ $New, $Continue, $Settings, $Quit ]
var index : int = 0

@onready var ng_warning_panel : NinePatchRect = $WarningPanel
@onready var ng_warning_cursor : TextureRect = $WarningPanel/Cursor
@onready var ng_warning_options : Array[Label] = [ $WarningPanel/Cancel, $WarningPanel/Continue ]

var np_index : int = -1
@onready var name_panel : NinePatchRect = $NamePanel
@onready var np_timer : Timer = $NamePanel/Timer
@onready var np_cursor_0 : ColorRect = $NamePanel/Highlight
@onready var np_cursor_1 : TextureRect = $NamePanel/Cursor
@onready var np_textedit : Label = $NamePanel/Namespace
@onready var np_options : Array[Label] = [ $NamePanel/Cancel, $NamePanel/Continue ]

func _ready() -> void:
	if not SaveData.has_save_file():
		options[1].add_theme_color_override("font_color", Global.COLOR_GRAY_4)

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if np_index >= 0:
		if np_textedit.text.count(".") < 12:
			np_options[1].remove_theme_color_override("font_color")
		else:
			np_options[1].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
		if np_index > 0:
			for i : int in 26:
				if Input.is_key_pressed(KEY_A + i) and np_timer.time_left == 0:
					np_timer.start()
					np_textedit.text[np_index - 1] = char(KEY_A + i)
					np_index = mini(np_index + 1, 12)
					return
			if (Input.is_key_pressed(KEY_BACKSPACE) or Input.is_key_pressed(KEY_DELETE)) and np_timer.time_left == 0:
				np_timer.start()
				if np_index == 1:
					np_textedit.text[0] = '.'
				else:
					np_index = maxi(np_index - 1, 1)
					np_textedit.text[np_index] = '.'
				return
			if Input.is_key_pressed(KEY_SPACE) and np_timer.time_left == 0:
				np_timer.start()
				np_textedit.text[np_index - 1] = ' '
				np_index = mini(np_index + 1, 12)
				return
			if Input.is_action_just_pressed("menu_select"):
				np_index = 0
		else:
			if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
				index = (index + 2) % 3
				nav_sfx.play()
			if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
				index = (index + 1) % 3
				nav_sfx.play()
			if index == 0:
				np_cursor_0.show()
				np_cursor_1.hide()
			else:
				np_cursor_0.hide()
				np_cursor_1.position.x = np_options[index - 1].position.x + 109
				np_cursor_1.show()
			if Input.is_action_just_pressed("menu_select"):
				if index == 2:
					if np_textedit.text.count(".") < 12:
						select_sfx.play()
						ignore_input = true
						SaveData.load_defaults()
						SaveData.hunter_unit.display_name = np_textedit.text.replace('.','')
						SaveData.hunter_name = SaveData.hunter_unit.display_name
						Main.i.change_scene("res://Scenes/Overworld/Map/town.tscn", 0.0)
						return
					fail_sfx.play()
				elif index == 1:
					select_sfx.play()
					index = 0
					np_index = -1
					pointer.position.y = options[index].position.y + 4
					name_panel.hide()
				else:
					select_sfx.play()
					np_index = 13 - np_textedit.text.count(".")
	elif index >= 0:
		if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
			index = (index + 3) % 4
			nav_sfx.play()
		if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
			index = (index + 1) % 4
			nav_sfx.play()
		
		pointer.position.y = options[index].position.y + 4
		
		if Input.is_action_just_pressed("menu_select"):
			ignore_input = true
			if index == 1:
				if SaveData.has_save_file():
					SaveData.load_save_file()
					Main.i.change_scene("res://Scenes/Overworld/Map/town.tscn", 1.0 if SaveData.altar_level <= 0 else 1.0)
				else:
					ignore_input = false
					fail_sfx.play()
					return
			select_sfx.play()
			if index == 0:
				ignore_input = false
				if SaveData.has_save_file():
					index = -1
					ng_warning_panel.show()
					ng_warning_cursor.position.x = ng_warning_options[-index - 1].position.x + 109
					return
				np_index = 0
				name_panel.show()
			elif index == 2:
				Main.i.open_settings()
				ignore_input = false
			elif index == 3:
				get_tree().call_deferred("quit")
	else:
		if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
			index = ((index - 1) & 1) - 2
			nav_sfx.play()
		ng_warning_cursor.position.x = ng_warning_options[-index - 1].position.x + 109
		if Input.is_action_just_pressed("menu_select"):
			ignore_input = true
			select_sfx.play()
			if index == -1:
				index = 0
				pointer.position.y = options[index].position.y + 4
				ng_warning_panel.hide()
				ignore_input = false
			else:
				index = 0
				np_index = 0
				name_panel.show()
				ng_warning_panel.hide()
				ignore_input = false
			return
		if Input.is_action_just_pressed("menu_cancel"):
			fail_sfx.play()
			index = 0
			pointer.position.y = options[index].position.y + 4
			ng_warning_panel.hide()
