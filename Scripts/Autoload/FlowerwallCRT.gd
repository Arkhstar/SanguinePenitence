extends CanvasLayer

@onready var crt_mat : ShaderMaterial = $crt_shader.get_material()

func set_ca(enabled : bool) -> void:
	crt_mat.set_shader_parameter("enable_chromatic_aberration", enabled)

func get_ca() -> bool:
	return crt_mat.get_shader_parameter("enable_chromatic_aberration")
