class_name PlayerBattleDisplay
extends NinePatchRect

@onready var _name : Label = $Name
@onready var _health : Label = $Health
@onready var _sharpness : Label = $Sharpness
@onready var _icons : Array[StatusIcon] = [ $StatusIcon1, $StatusIcon2, $StatusIcon3, $StatusIcon4, $StatusIcon5, $StatusIcon6 ]
@onready var _timer : TextureProgressBar = $ATB
@onready var _indicators : Array[TargetIndicator] = [ $HBoxContainer/Control1/TargetIndicator, $HBoxContainer/Control2/TargetIndicator, $HBoxContainer/Control3/TargetIndicator, $HBoxContainer/Control4/TargetIndicator ]
@onready var _qte : Label = $ATB/QTE

var unit : PlayerUnit = null :
	set(v):
		unit = v
		update()

var atb : ATBTimer = null :
	set(v):
		atb = v
		if atb:
			atb.update_qte.connect(set_qte_popup)
		update()

func update() -> void:
	if unit == null or atb == null:
		hide()
		return
	show()
	_name.text = unit.display_name.left(11)
	_health.text = "HP: %3d/%3d" % [ unit.health, unit.max_health ]
	_sharpness.text = "SHARPNESS:%s" % unit.sharpness_rank_as_char()
	for i : int in 6:
		_icons[i].set_stack_text(unit.effects[i])
		if unit.effects[i] > 0:
			_icons[i].set_icon_colors(Color("8a9094"), Color("495058"))
		else:
			_icons[i].set_icon_colors(Color("394047"), Color.TRANSPARENT)
	_timer.max_value = atb.maximum
	_timer.value = atb.value

func hide_indicators(is_null : Array[bool]) -> void:
	for i : int in 4:
		_indicators[i].get_parent().visible = is_null[i]

func set_targeted(by : int) -> void:
	_indicators[by].enqueue(1)

func release_targeted(by : int) -> void:
	_indicators[by].enqueue(0)

func cancel_targeted(by : int) -> void:
	_indicators[by].enqueue(2)

func set_qte_popup(qte : int) -> void:
	if qte >= 0:
		_qte.text = str(qte)
	else:
		_qte.text = ""
