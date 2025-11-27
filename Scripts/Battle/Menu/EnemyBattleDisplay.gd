class_name EnemyBattleDisplay
extends NinePatchRect

@onready var _name : Label = $Name
@onready var _icons : Array[StatusIcon] = [ $StatusIcon1, $StatusIcon2, $StatusIcon3, $StatusIcon4, $StatusIcon5, $StatusIcon6 ]
@onready var _vfx : AnimatedSprite2D = $AttackVFX
@onready var _unit_mat : ShaderMaterial = $Unit.get_material()

var unit : EnemyUnit = null :
	set(v):
		unit = v
		update()

func update() -> void:
	if not unit:
		return
	_name.text = unit.display_name.left(11)
	for i : int in 6:
		_icons[i].set_stack_text(unit.effects[i])
		if unit.effects[i] > 0:
			_icons[i].set_icon_colors(Global.COLOR_GRAY_0, Global.COLOR_GRAY_1)
		else:
			_icons[i].set_icon_colors(Global.COLOR_GRAY_2, Global.COLOR_GRAY_3)

func damage_effect(type : BattleMain.AttackType) -> void:
	_vfx.play(str(type))
	_vfx.show()
	while _vfx.is_playing():
		await RenderingServer.frame_post_draw
	_vfx.hide()

func death_anim() -> void:
	var lambda : Callable = func(x : float) -> void: _unit_mat.set_shader_parameter("sensitivity", x)
	var t : Tween = create_tween()
	t.tween_method(lambda, 0.0, 1.0, 2.0 / 3.0)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
