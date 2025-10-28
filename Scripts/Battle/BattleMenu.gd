class_name BattleMenu
extends NinePatchRect

signal selection

var ignore_input : bool = true

@onready var pointer : TextureRect = $Cursor
@onready var options : Array[Label] = [ $Attack, $Cast, $Reagent, $Item, $Support ]
var index : int = 0

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
		index = (index + 4) % 5
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
		index = (index + 1) % 5
	pointer.position.y = options[index].position.y
	if Input.is_action_just_pressed("menu_select"):
		selection.emit(index)
