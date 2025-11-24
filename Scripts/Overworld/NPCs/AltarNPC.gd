class_name AltarNPC
extends NPC

var timer : float
var _i : int = 0
@export var _j : int = 0
@onready var mat : ShaderMaterial = $Sprite2D.get_material()

var color_array : Array[Color] = []

func _ready() -> void:
	super()
	update_array()

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		timer += 1./6.0
		_i = (_i + 1) & 7
		update_array()
		var current : Array = mat.get_shader_parameter("colors")
		if _j < 0:
			mat.set_shader_parameter("colors", [ Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 0:
			mat.set_shader_parameter("colors", [ color_array[0 if _i == 0 else 1], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 1:
			mat.set_shader_parameter("colors", [ color_array[0 if _i > 1 else 1], current[0], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 2:
			mat.set_shader_parameter("colors", [ color_array[0 if _i > 2 else _i & 3], current[0], current[1], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 3:
			mat.set_shader_parameter("colors", [ color_array[_i & 3 if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 4:
			mat.set_shader_parameter("colors", [ color_array[_i & 3 if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], current[3], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 5:
			mat.set_shader_parameter("colors", [ color_array[_i & 3 if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], current[3], current[4], Global.COLOR_GRAY_5, Global.COLOR_GRAY_5 ])
		elif _j == 6:
			mat.set_shader_parameter("colors", [ color_array[_i & 3 if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], current[3], current[4], current[5], color_array[(_i & 4) >> 2] ])
		elif _j == 7:
			mat.set_shader_parameter("colors", [ color_array[_i if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], current[3], current[4], current[5], color_array[0 if _i < 2 or (_i > 3 and _i < 6) else (1 if _i < 6 else 4)] ])
		else:
			mat.set_shader_parameter("colors", [ color_array[_i if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], current[3], current[4], current[5], current[6] ])

func update_array() -> void:
	if SaveData.altar_level >= 3000:
		_j = 8
	elif SaveData.altar_level >= 2500:
		_j = 7
	elif SaveData.altar_level >= 2000:
		_j = 6
	elif SaveData.altar_level >= 1650:
		_j = 5
	elif SaveData.altar_level >= 1350:
		_j = 4
	elif SaveData.altar_level >= 1050:
		_j = 3
	elif SaveData.altar_level >= 750:
		_j = 2
	elif SaveData.altar_level >= 500:
		_j = 1
	elif SaveData.altar_level >= 250:
		_j = 0
	else:
		_j = -1
	if _j > 6:
		color_array = [ Global.COLOR_BLUE_0, Global.COLOR_BLUE_1, Global.COLOR_BLUE_2, Global.COLOR_BLUE_3, Global.COLOR_GRAY_5 ]
	else:
		color_array = [ Global.COLOR_GRAY_5, Global.COLOR_BLUE_0, Global.COLOR_BLUE_1, Global.COLOR_BLUE_2, Global.COLOR_BLUE_3 ]
