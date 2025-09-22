class_name CharacterSprite
extends Sprite2D

@onready var body : CharacterBody2D = self.get_parent()
var _bytes : int = 0

func _direction() -> void:
	if (body.velocity.x < 0 and _bytes&3 == 2) or (body.velocity.x > 0 and _bytes&3 == 3) or (body.velocity.y < 0 and _bytes&3 == 1) or (body.velocity.y > 0 and _bytes&3 == 0):
		return
	if body.velocity.x == 0:
		if body.velocity.y < 0:
			_bytes = 1
		else:
			_bytes = 0
	else:
		if body.velocity.x < 0:
			_bytes = 2
		else:
			_bytes = 3

func _physics_process(_delta: float) -> void:
	if body.velocity == Vector2.ZERO:
		frame = 4 * (_bytes&3) + (2 * (frame / 2)) % 4
		return
	
	_bytes = (_bytes & 3) | ((_bytes >> 1) & ~3)
	_direction()
	if _bytes & ~3 == 0:
		_bytes |= 0xFFC
		frame = 4 * (_bytes&3) + (frame + 1) % 4
