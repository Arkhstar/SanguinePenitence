class_name Altar
extends Sprite2D

@onready var area : Area2D = $Area2D
@onready var prompt : Sprite2D = $Sprite2D

func _on_area_entered(_body: Node2D) -> void:
	prompt.show()

func _on_area_exited(_body: Node2D) -> void:
	prompt.hide()
