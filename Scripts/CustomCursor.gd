extends CanvasLayer

@onready var tex : TextureRect = $Cursor

func _physics_process(_delta: float) -> void:
	tex.global_position = tex.get_global_mouse_position()
	Input.mouse_mode = (Input.MOUSE_MODE_CONFINED_HIDDEN if Config.confine_mouse_to_window else Input.MOUSE_MODE_HIDDEN)
