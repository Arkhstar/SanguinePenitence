class_name SellMenu
extends NinePatchRect

signal exit

var ignore_input : bool = true

@onready var options : Array[Label] = [
	$D,
	$C,
	$B,
	$A,
	$S,
	$all,
	$none,
	$Sell,
	$Exit
]

@onready var cursor : ColorRect = $Highlight
@onready var cursor_indicator : TextureRect = $Highlight/Cursor
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
	if option < 5:
		cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
		cursor.size.x = 172.0
	else:
		cursor.global_position = options[option].global_position + Vector2(54.0, -1.0)
		cursor.size.x = 202.0
	cursor_indicator.position.x = cursor.size.x - 2
	if Input.is_action_just_pressed("menu_select"):
		select_sfx.play()
		if option < 5:
			ignore_input = true
			cursor.global_position = options[option].option.global_position - Vector2(1.0, 1.0)
			cursor.size.x = 112
			cursor_indicator.hide()
			await RenderingServer.frame_post_draw
			await RenderingServer.frame_post_draw
			options[option].selected = true
		elif option == 5:
			for i : int in 5:
				options[i].set_all()
		elif option == 6:
			for i : int in 5:
				options[i].set_none()
		elif option == 7:
			var profit : int = 0
			for i : int in 5:
				var quantity : int = options[i].v
				var cost : int = [10, 25, 100, 250, 1000][i]
				for j : int in quantity:
					if profit + SaveData.obols >= SaveData.coinpurse:
						break
					SaveData.inventory.monster_parts[4-i] -= 1
					profit += cost
				options[i].init(4-i)
			SaveData.obols += profit
		else:
			ignore_input = true
			exit.emit()
		return
	if Input.is_action_just_pressed("menu_cancel"):
		ignore_input = true
		exit.emit()

func return_from_setting() -> void:
	ignore_input = false
	cursor.position = options[option].position - Vector2(1.0, 1.0)
	cursor.size.x = 172.0
	cursor_indicator.show()

func reset() -> void:
	option = 0
	cursor.global_position = options[option].global_position - Vector2(1.0, 1.0)
	cursor.size.x = 172.0
	cursor_indicator.show()
	for i : int in 5:
		options[i].reset(0)

func _ready() -> void:
	options[0].init(Inventory.MonsterPartGrade.GRADE_D)
	options[1].init(Inventory.MonsterPartGrade.GRADE_C)
	options[2].init(Inventory.MonsterPartGrade.GRADE_B)
	options[3].init(Inventory.MonsterPartGrade.GRADE_A)
	options[4].init(Inventory.MonsterPartGrade.GRADE_S)
	
	for i : int in 5:
		options[i].exit.connect(return_from_setting)
	
	reset()

func open() -> void:
	reset()
	show()
	ignore_input = false

func close() -> void:
	ignore_input = true
	hide()
