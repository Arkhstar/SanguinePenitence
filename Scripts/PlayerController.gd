class_name PlayerController
extends Node2D

static var instance : PlayerController

var allow_input : bool = true

var is_moving : bool
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray : RayCast2D = $RayCast2D

var slash_cd : float = 0.0
@onready var slash : AnimatedSprite2D = $Slash
@onready var slash_hitbox : Area2D = $HitBox

var durability : Vector2i = Vector2i(50, 20)
var durability_max : Vector2i = Vector2i(50, 20)
var iframes : float = 0.0

signal died

func _do_move(offset : Vector2) -> void:
	if is_moving:
		return
	
	if offset.x != 0.0:
		scale.x = -1.0 if offset.x > 0 else 1.0
	
	#region
	if offset.x == 0:
		ray.target_position = Vector2(0.0, 16 * signf(offset.y))
		ray.position = Vector2(-8.0, 8.0 * signf(offset.y))
		ray.force_raycast_update()
		if ray.is_colliding():
			return
		ray.position.x = 8.0
		ray.force_raycast_update()
		if ray.is_colliding():
			return
	elif offset.y == 0:
		ray.target_position = Vector2(16.0 * signf(offset.x) * scale.x, 0.0)
		ray.position = Vector2(8.0 * signf(offset.x) * scale.x, -8.0)
		ray.force_raycast_update()
		if ray.is_colliding():
			return
		ray.position.y = 8.0
		ray.force_raycast_update()
		if ray.is_colliding():
			return
	else:
		ray.target_position = Vector2(16.0 * signf(offset.x) * scale.x, 16.0 * signf(offset.y))
		ray.position = Vector2(8.0 * signf(offset.x) * scale.x, 8.0 * signf(offset.y))
		ray.force_raycast_update()
		if ray.is_colliding():
			return
		ray.position.x = -ray.position.x
		ray.force_raycast_update()
		if ray.is_colliding():
			return
		ray.position = -ray.position
		ray.force_raycast_update()
		if ray.is_colliding():
			return
	#endregion
	
	is_moving = true
	
	var t : Tween = create_tween()
	t.tween_property(sprite, "position", Vector2.ZERO, 0.125).set_trans(Tween.TRANS_BOUNCE)
	
	sprite.position = Vector2(-offset.x * scale.x, -offset.y)
	global_position += offset
	
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	is_moving = false

func _do_slash() -> void:
	if slash_cd > 0.0 or is_moving:
		return
	slash_cd = 0.255
	is_moving = true
	
	var hits : Dictionary = {}
	slash.play("default")
	while slash.is_playing():
		for body : Node2D in slash_hitbox.get_overlapping_areas():
			if body is AbstractEnemy and hits.get(body, true) and slash.frame < 5:
				hits[body] = false
				body.on_hit(ceili(durability.x / 5.0) + 1, false)
				durability.x = maxi(durability.x - 1, 0)
		await RenderingServer.frame_post_draw
	
	is_moving = false

func take_damage(amount : int) -> void:
	if iframes > 0.0:
		return
	durability.y = maxi(durability.y - amount, 0)
	iframes = 0.25
	if durability.y <= 0:
		allow_input = false
		died.emit()
	sprite.material.set_shader_parameter("enabled", true)
	for i : int in 8:
		await RenderingServer.frame_post_draw
	sprite.material.set_shader_parameter("enabled", false)

func _ready() -> void:
	instance = self

func _physics_process(delta: float) -> void:
	slash_cd = maxf(slash_cd - delta, 0.0)
	iframes = maxf(iframes - delta, 0.0)
	if allow_input:
		if Input.is_action_pressed("slash"):
			_do_slash()
		var input : Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		if input:
			_do_move(input * 16.0)
