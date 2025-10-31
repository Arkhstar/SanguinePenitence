class_name AltarMenu
extends NPCMenu

@onready var amount : Label = $NinePatchRect/Amount
@onready var options : Array[Label] = [ $NinePatchRect/Agree, $NinePatchRect/Disagree ]
@onready var cursor : TextureRect = $NinePatchRect/Cursor
var choice : bool = false

func calc_cost() -> int:
	return 250 * (SaveData.altar_level + 1)

func init() -> void:
	choice = false
	amount.text = str(calc_cost())
	if SaveData.obols < calc_cost():
		options[0].add_theme_color_override("font_color", Color("#621f31"))

func update(_delta : float) -> void:
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_right"):
		choice = not choice
	cursor.position.y = options[int(choice)].position.y
	
	if Input.is_action_just_pressed("menu_select"):
		if choice:
			close()
		else:
			if SaveData.obols < calc_cost():
				print("ALTAR BUY ERROR SFX")
			else:
				print("ALTAR BUY SUCCESS SFX")
				SaveData.obols -= calc_cost()
				SaveData.altar_level += 1
				close()
