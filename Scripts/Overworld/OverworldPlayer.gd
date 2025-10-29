class_name OverworldPlayer
extends Node2D

var ignore_input : bool = false
var is_moving : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var ray : RayCast2D = $RayCast2D

func check_for_collision_by_ray(d : Vector2) -> bool:
	ray.target_position = Vector2(16.0 * d)
	ray.force_raycast_update()
	return not ray.is_colliding()

func move(offset : Vector2i) -> void:
	is_moving = true
	var sprite_position : Vector2 = sprite.global_position
	var t : Tween = create_tween()
	t.tween_property(sprite, "position", Vector2.ZERO, 0.15)
	position += 16.0 * offset
	sprite.global_position = sprite_position
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	is_moving = false

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	if not is_moving:
		var direction : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		direction = Vector2(signf(direction.x) * roundf(absf(direction.x)), signf(direction.y) * roundf(absf(direction.y)))
		if direction and check_for_collision_by_ray(direction):
			move(direction)
