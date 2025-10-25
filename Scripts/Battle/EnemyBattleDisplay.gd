class_name EnemyBattleDisplay
extends NinePatchRect

@onready var _name : Label = $Name
@onready var _icons : Array[StatusIcon] = [ $StatusIcon1, $StatusIcon2, $StatusIcon3, $StatusIcon4, $StatusIcon5, $StatusIcon6 ]

var unit : EnemyUnit = null :
	set(v):
		unit = v
		update()

func update() -> void:
	if not unit:
		hide()
		return
	show()
	_name.text = unit.display_name.left(11)
	for i : int in 6:
		_icons[i].set_stack_text(unit.effects[i])
		if unit.effects[i] > 0:
			_icons[i].set_icon_colors(Color.RED, Color.BLUE)
		else:
			_icons[i].set_icon_colors(Color.TRANSPARENT, Color.TRANSPARENT)
