class_name CombatMenu
extends NinePatchRect

var _allow_input : bool = false

@onready var _options : Array[Label] = [ $Attack, $Cast, $Sharpen, $Item ]
@onready var _selector : TextureRect = $Selector
@onready var _selector_cycle_timer : Timer = $Selector/Timer
var _idx : int = 0

signal selection

func enable(sfx : bool = true) -> void:
	_idx = 0
	_selector.position.y = _options[_idx].position.y
	_allow_input = true
	show()
	if sfx:
		print("MENU POPUP SFX")

func fail_selection() -> void:
	_allow_input = true
	print("FAIL SELECTION SFX")

func _physics_process(_delta: float) -> void:
	if _allow_input:
		if Input.is_action_just_pressed("menu_up") or (Input.is_action_pressed("menu_up") and _selector_cycle_timer.time_left == 0):
			_idx = (_idx + 3) % 4
			_selector_cycle_timer.start()
		if Input.is_action_just_pressed("menu_down") or (Input.is_action_pressed("menu_down") and _selector_cycle_timer.time_left == 0):
			_idx = (_idx + 1) % 4
			_selector_cycle_timer.start()
		_selector.position.y = _options[_idx].position.y
		if Input.is_action_just_pressed("menu_select"):
			selection.emit(_idx)
			_allow_input = false
