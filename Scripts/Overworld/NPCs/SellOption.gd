class_name SellOption
extends Label

signal exit

var selected : bool = false :
	set(value):
		selected = value
		if selected:
			o = v

@onready var timer : Timer = $Timer

@onready var option : Label = $Option
@onready var l : TextureRect = $Option/L
@onready var r : TextureRect = $Option/R

@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

var i : int = -1
var v : int = 0
var o : int = 0

func update_option(s : int) -> void:
	v = clampi(s, 0, SaveData.inventory.monster_parts[i])
	option.text = "%4d/%4d" % [v, SaveData.inventory.monster_parts[i]]
	if v == 0:
		l.texture = Global.TEXTURE_OPTION_CYCLE_OFF
	else:
		l.texture = Global.TEXTURE_OPTION_CYCLE_ON
	if v == SaveData.inventory.monster_parts[i]:
		r.texture = Global.TEXTURE_OPTION_CYCLE_OFF
	else:
		r.texture = Global.TEXTURE_OPTION_CYCLE_ON

func reset(o_val : int) -> void:
	o = o_val
	update_option(o)

func init(grade : Inventory.MonsterPartGrade) -> void:
	text = "MONSTER PARTS -%s-" % ['S', 'A', 'B', 'C', 'D'][grade]
	i = grade
	o = 0
	update_option(o)

func _physics_process(_delta: float) -> void:
	if selected:
		if Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_left") or Input.is_action_pressed("menu_up"))):
			timer.start()
			if v == 0:
				fail_sfx.play()
			else:
				select_sfx.play()
			update_option(v - 1)
		if Input.is_action_just_pressed("menu_right") or Input.is_action_just_pressed("menu_down") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_right") or Input.is_action_pressed("menu_down"))):
			timer.start()
			if v == SaveData.inventory.monster_parts[i]:
				fail_sfx.play()
			else:
				select_sfx.play()
			update_option(v + 1)
		if Input.is_action_just_pressed("menu_select"):
			selected = false
			select_sfx.play()
			o = v
			exit.emit()
		if Input.is_action_just_pressed("menu_cancel"):
			selected = false
			fail_sfx.play()
			update_option(o)
			exit.emit()

func set_all() -> void:
	o = SaveData.inventory.monster_parts[i]
	update_option(o)

func set_none() -> void:
	o = 0
	update_option(o)
