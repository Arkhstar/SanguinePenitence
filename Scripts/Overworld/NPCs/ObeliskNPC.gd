class_name ObeliskNPC
extends NPC

@export var id : int = -1
var active : bool
var timer : float
var _i : int = 0
@onready var mat : ShaderMaterial = $Sprite2D.get_material()
const COLORS : Array[Color] = [ Color("#222b47"), Color("#354461"), Color("#4b6c81"), Color("#729f9f") ]

func _ready() -> void:
	super()
	if id < 0 or SaveData.obelisks & (1 << id):
		activate()

func _process(delta: float) -> void:
	if active:
		timer -= delta
		if timer <= 0.0:
			timer += 1./6.0
			_i = (_i + 1) & 7
			var current : Array = mat.get_shader_parameter("colors")
			mat.set_shader_parameter("colors", [ COLORS[_i if _i < 4 else 3 - (_i & 3)], current[0], current[1], current[2], COLORS[_i if _i < 4 else 3 - (_i & 3)], current[4], current[5], current[6] ])

func activate() -> void:
	active = true
	mat.set_shader_parameter("colors", [ COLORS[0], COLORS[0], COLORS[0], COLORS[0], COLORS[0], COLORS[0], COLORS[0], COLORS[0] ])
