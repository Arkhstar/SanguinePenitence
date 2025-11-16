class_name BattleMenu
extends NinePatchRect

signal selection

var ignore_input : bool = true
@onready var timer : Timer = $Timer

@onready var pointer : TextureRect = $Cursor
@onready var options : Array[Label] = [ $Attack, $Cast, $Reagent, $Item, $Support ]
var index : int = 0

@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select
@onready var fail_sfx : AudioStreamPlayer = $Fail

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
		index = (index + 4) % 5
		nav_sfx.play()
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
		index = (index + 1) % 5
		nav_sfx.play()
	pointer.position.y = options[index].position.y
	if Input.is_action_just_pressed("menu_select"):
		selection.emit(index)

func activate() -> void:
	timer.start()
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	ignore_input = false

func update_availability(actor : PlayerUnit, allies : bool) -> void:
	options[1].remove_theme_color_override("font_color")
	options[2].remove_theme_color_override("font_color")
	options[3].remove_theme_color_override("font_color")
	options[4].remove_theme_color_override("font_color")
	if actor.reagent == 0 or actor.effects[BattleUnit.StatusEffect.FAITHLESS] > 0:
		options[1].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
	if SaveData.inventory.reagents.count(0) == Inventory.ReagentItem.size() or actor.effects[BattleUnit.StatusEffect.GREED] > 0 or actor.effects[BattleUnit.StatusEffect.FAITHLESS] > 0:
		options[2].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
	if SaveData.inventory.consumables.count(0) == Inventory.ConsumableItem.size() or actor.effects[BattleUnit.StatusEffect.GREED] > 0:
		options[3].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
	if not allies:
		options[4].add_theme_color_override("font_color", Global.COLOR_GRAY_4)
