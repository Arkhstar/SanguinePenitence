class_name BuyOption
extends Label

signal exit

const LIT : Texture = preload("res://Textures/UI/CycleLight.png")
const UNLIT : Texture = preload("res://Textures/UI/CycleDark.png")

var selected : bool = false

@onready var timer : Timer = $Timer

@onready var option : Label = $Option
@onready var l : TextureRect = $Option/L
@onready var r : TextureRect = $Option/R

@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

var q : int = 0
var cost : int = 0
var o : int = 0
var cp : int = 0

func update_option(s : int) -> void:
	q = s
	option.text = "%2d:%5d" % [q, q * cost]
	if q == 0:
		l.texture = UNLIT
	else:
		l.texture = LIT
	if q * cost + cost + cp > SaveData.obols:
		r.texture = UNLIT
	else:
		r.texture = LIT

func reset(o_val : int) -> void:
	o = o_val
	update_option(o)

func init(title : String, cpu : int, c : int) -> void:
	text = title
	cost = cpu
	o = 0
	cp = c
	update_option(o)

func _physics_process(_delta: float) -> void:
	if selected:
		if Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_left") or Input.is_action_pressed("menu_up"))):
			timer.start()
			if q == 0:
				fail_sfx.play()
			else:
				select_sfx.play()
				update_option(q - 1)
		if Input.is_action_just_pressed("menu_right") or Input.is_action_just_pressed("menu_down") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_right") or Input.is_action_pressed("menu_down"))):
			timer.start()
			if q * cost + cost + cp > SaveData.obols:
				fail_sfx.play()
			else:
				select_sfx.play()
				update_option(q + 1)
		if Input.is_action_just_pressed("menu_select"):
			selected = false
			select_sfx.play()
			o = q
			exit.emit()
		if Input.is_action_just_pressed("menu_cancel"):
			selected = false
			fail_sfx.play()
			update_option(o)
			exit.emit()
