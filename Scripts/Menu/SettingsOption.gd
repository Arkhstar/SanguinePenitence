class_name SettingsOption
extends Label

signal exit

const LIT : Texture = preload("res://Textures/Menu/Selector/CycleLight.png")
const UNLIT : Texture = preload("res://Textures/Menu/Selector/CycleDark.png")

var selected : bool = false :
	set(value):
		selected = value
		if selected:
			c = g.call()

@onready var timer : Timer = $Timer

@onready var option : Label = $Option
@onready var l : TextureRect = $Option/L
@onready var r : TextureRect = $Option/R

var g : Callable
var s : Callable
var d : Callable
var p : Callable
var n : Callable

var c : Variant
var v : Variant
var i : Variant
var x : Variant

var u : bool = true

@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

func update_option() -> void:
	option.text = d.call(v)
	if u:
		s.call(v)
	if v == i:
		l.texture = UNLIT
	else:
		l.texture = LIT
	if v == x:
		r.texture = UNLIT
	else:
		r.texture = LIT

func init(title : String, get_value : Callable, set_value : Callable, display_value : Callable, min_value : Variant, max_value : Variant, inc : Callable, dec : Callable, set_on_update : bool = true) -> void:
	text = title
	g = get_value
	s = set_value
	d = display_value
	i = min_value
	x = max_value
	p = inc
	n = dec
	u = set_on_update
	v = g.call()
	update_option()

func _physics_process(_delta: float) -> void:
	if selected:
		if Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_up") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_left") or Input.is_action_pressed("menu_up"))):
			timer.start()
			var temp : Variant = v
			v = n.call(v)
			if temp != v:
				select_sfx.play()
			else:
				fail_sfx.play()
			update_option()
		if Input.is_action_just_pressed("menu_right") or Input.is_action_just_pressed("menu_down") or (timer.time_left <= 0 and (Input.is_action_pressed("menu_right") or Input.is_action_pressed("menu_down"))):
			timer.start()
			var temp : Variant = v
			v = p.call(v)
			if temp != v:
				select_sfx.play()
			else:
				fail_sfx.play()
			update_option()
		if Input.is_action_just_pressed("menu_select"):
			selected = false
			select_sfx.play()
			s.call(v)
			exit.emit()
		if Input.is_action_just_pressed("menu_cancel"):
			selected = false
			fail_sfx.play()
			if v != c:
				s.call(c)
			v = c
			update_option()
			exit.emit()
