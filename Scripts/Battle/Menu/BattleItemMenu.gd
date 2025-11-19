class_name BattleItemMenu
extends NinePatchRect

signal selection

var ignore_input : bool = true
@onready var timer : Timer = $Timer

@onready var pointer : TextureRect = $Cursor
@onready var options : Array[Label] = [ $A, $B, $C, $D, $E ]
var index : int = 0
var page : int = 0
var _is_cmbl : bool = true

@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
		if index == 0:
			if _is_cmbl:
				index = Inventory.ConsumableItem.size() - 1
				page = Inventory.ConsumableItem.size() - 5
			else:
				index = Inventory.ReagentItem.size() - 1
				page = Inventory.ReagentItem.size() - 5
		else:
			index -= 1
			if index - page < 0:
				page -= 1
		update()
		nav_sfx.play()
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
		if (_is_cmbl and index == Inventory.ConsumableItem.size() - 1) or ((not _is_cmbl) and index == Inventory.ReagentItem.size() - 1):
			index = 0
			page = 0
		else:
			index += 1
			if index - page >= 5:
				page += 1
		update()
		nav_sfx.play()
	pointer.position.y = options[index - page].position.y
	if Input.is_action_just_pressed("menu_select"):
		selection.emit(index)
		return
	if Input.is_action_just_pressed("menu_cancel"):
		selection.emit(-1)

func activate(consumables_or_reagents : bool) -> void:
	_is_cmbl = consumables_or_reagents
	timer.start()
	index = 0
	page = 0
	pointer.position.y = options[index - page].position.y
	update()
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	ignore_input = false

func update() -> void:
	if _is_cmbl:
		for i : int in 5:
			var quantity : int = SaveData.inventory.consumables[i + page]
			options[i].text = "%s: %2d" % [["HP POTN","WHTSTN ", "C BURN ", "C BLEED", "C CURSE", "C GREED", "C FTHLS", "C HEAVY"][i + page], quantity]
			if quantity <= 0:
				options[i].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
			else:
				options[i].remove_theme_color_override("font_color")
	else:
		for i : int in 5:
			var quantity : int = SaveData.inventory.reagents[i + page]
			options[i].text = "%s: %d" % [["BURN 1 ", "BURN 2 ", "BLEED 1", "BLEED 2", "CURSE 1", "HEAVY 1", "DOT 1  "][i + page], quantity]
			if quantity <= 0:
				options[i].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
			else:
				options[i].remove_theme_color_override("font_color")
