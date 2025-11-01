class_name OverworldHUD
extends CanvasLayer

@onready var obol_container : NinePatchRect = $NinePatchRect
@onready var obol_label : Label = $NinePatchRect/Label

func _process(delta: float) -> void:
	if SaveData.altar_level <= 0:
		obol_container.modulate.a = 0
	else:
		obol_container.modulate.a = lerpf(obol_container.modulate.a, 1.0, delta)
	obol_label.text = str(SaveData.obols)
