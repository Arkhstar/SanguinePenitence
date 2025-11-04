class_name PulseVFX
extends TextureRect

var t : Tween
var _a : bool = false

func _ready() -> void:
	visible = Config.battle_pulse_effect

func pulse() -> void:
	if _a:
		if t and t.is_running():
			t.kill()
		modulate = Color.WHITE
		t = create_tween()
		t.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
		t.play()
	_a = not _a
