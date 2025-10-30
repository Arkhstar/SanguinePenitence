class_name OverworldHUD
extends CanvasLayer

@onready var obol_label : Label = $NinePatchRect/Label

func _process(_delta: float) -> void:
	obol_label.text = str(SaveData.obols)
