class_name PlayerController
extends Node2D

static var instance : PlayerController

var allow_input : bool = true

var is_moving : bool
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var slash_cd : float = 0.0
@onready var slash : AnimatedSprite2D = $Slash
@onready var slash_hitbox : Area2D = $HitBox

var durability : Vector2i = Vector2i(50, 50)

func do_move(offset : Vector2) -> void:
	if is_moving:
		return
	is_moving = true
	
	var t : Tween = create_tween()
	t.tween_property(sprite, "position", Vector2.ZERO, 0.125).set_trans(Tween.TRANS_BOUNCE)
	
	if offset.x != 0.0:
		scale.x = -1.0 if offset.x > 0 else 1.0
	
	sprite.position = Vector2(-offset.x * scale.x, -offset.y)
	global_position += offset
	
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	is_moving = false

func do_slash() -> void:
	if slash_cd > 0.0 or is_moving:
		return
	slash_cd = 0.25
	is_moving = true
	
	slash.play("default")
	while slash.is_playing():
		for body : Node2D in slash_hitbox.get_overlapping_bodies():
			if body is AbstractEnemy and slash.frame < 5:
				body.on_hit(ceili(durability.x / 5.0) + 1, false)
				durability.x = maxi(durability.x - 1, 0)
		await RenderingServer.frame_post_draw
	
	is_moving = false

func _ready() -> void:
	instance = self

func _physics_process(delta: float) -> void:
	slash_cd = maxf(slash_cd - delta, 0.0)
	if allow_input:
		if Input.is_action_pressed("slash"):
			do_slash()
		var input : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input:
			do_move(input * 16.0)
