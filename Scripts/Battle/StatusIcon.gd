class_name StatusIcon
extends Sprite2D

@onready var _mat : ShaderMaterial = get_material()

@onready var _label : Label = $Label

func set_icon_colors(primary : Color, secondary : Color) -> void:
	_mat.set_shader_parameter("on", primary)
	_mat.set_shader_parameter("off", secondary)

func set_stack_text(stacks : int) -> void:
	if stacks > 10:
		_label.text = 'A'
	elif stacks > 0:
		_label.text = str(stacks - 1)
	else:
		_label.text = ""
