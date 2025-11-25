class_name MetronomeVFX
extends Sprite2D

var current_frame : int

func _ready() -> void:
	visible = Config.battle_metronome_effect

func anim_in() -> void:
	frame = 0
	current_frame = (current_frame + 1) & 1

func anim_out() -> void:
	frame = current_frame + 1
