extends CharacterBody2D

var ignore_input : bool = false
const SPEED = 75.0

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	var direction : Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	if position.x > 256.:
		position.x -= 256.
	elif position.x < 0:
		position.x += 256
	if position.y > 240.:
		position.y -= 240.
	elif position.y < 0:
		position.y += 240.
