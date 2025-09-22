class_name WrapSprite
extends Sprite2D

@onready var sprite : Sprite2D = self.get_parent()

func _ready() -> void:
	texture = sprite.texture
	hframes = sprite.hframes
	vframes = sprite.vframes

func _process(_delta: float) -> void:
	frame = sprite.frame
