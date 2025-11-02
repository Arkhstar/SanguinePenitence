class_name MetronomeVFX
extends Sprite2D

var current_frame : int

func _ready() -> void:
	visible = Config.battle_metronome_effect

func pulse() -> void:
	current_frame = (current_frame + 1) & 3
	if current_frame & 1:
		frame = ((current_frame & 2) >> 1) + 1
	else:
		frame = 0
