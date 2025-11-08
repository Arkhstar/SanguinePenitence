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

func _ready() -> void:
	if not SaveData.has_save_file():
		options[1].add_theme_color_override("font_color", Color("#0f1216"))

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if index >= 0:
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
					Main.i.change_scene("res://Scenes/Overworld/town.tscn", 1.0 if SaveData.altar_level <= 0 else 1.0)
				else:
					ignore_input = false
					fail_sfx.play()
					return
			select_sfx.play()
			if index == 0:
				if SaveData.has_save_file():
					index = -1
					ng_warning_panel.show()
					ng_warning_cursor.position.x = ng_warning_options[-index - 1].position.x + 109
					ignore_input = false
					return
				SaveData.load_defaults()
				Main.i.change_scene("res://Scenes/Overworld/town.tscn", 0.0)
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
				SaveData.load_defaults()
				Main.i.change_scene("res://Scenes/Overworld/town.tscn", 0.0)
			return
		if Input.is_action_just_pressed("menu_cancel"):
			fail_sfx.play()
			index = 0
			pointer.position.y = options[index].position.y + 4
			ng_warning_panel.hide()
