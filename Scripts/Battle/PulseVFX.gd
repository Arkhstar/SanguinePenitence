class_name PulseVFX
extends TextureRect

var t : Tween

func _ready() -> void:
	visible = Config.battle_pulse_effect

func pulse() -> void:
	if t and t.is_running():
		t.custom_step(1)
	modulate = Color.WHITE
	t = create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	t.play()
