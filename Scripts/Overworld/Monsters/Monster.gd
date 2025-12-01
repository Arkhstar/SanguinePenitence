class_name Monster
extends Area2D

@export var encounter : Array[Array] = []
@export_enum("Normal", "Boss") var theme : int = 0
@onready var initiate_combat_sfx : AudioStreamPlayer = $InitiateCombatSFX

func _on_area_entered(_body: Node2D) -> void:
	freeze = true
	OverworldPlayer.i.ignore_input = true
	MusicStreamPlayer.adjust_volume(0.0, 1.0)
	initiate_combat_sfx.play()
	OverworldPlayer.i.cam.zoom = Vector2(1.002, 1.002)
	OverworldPlayer.i.cam.rotation_degrees = 0.1 * (1.0 if OverworldPlayer.i.sprite.flip_h else -1.0)
	TransitionScreen.fade_in(2.5)
	while initiate_combat_sfx.playing:
		OverworldPlayer.i.cam.rotation_degrees += OverworldPlayer.i.cam.rotation_degrees / 16.0;
		OverworldPlayer.i.cam.zoom += Vector2(OverworldPlayer.i.cam.zoom.x - 1.0, OverworldPlayer.i.cam.zoom.y - 1.0) / 16.0;
		await RenderingServer.frame_post_draw
	Main.i.call_deferred("change_to_battle_from_overworld", encounter.pick_random(), theme + MusicStreamPlayer.Song.BATTLE)
	queue_free()

var freeze : bool = false
var is_moving : bool = false

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray : RayCast2D = $RayCast2D
@onready var timer : Timer = $Timer

func check_for_collision_by_ray(d : Vector2) -> bool:
	ray.target_position = Vector2(24.0 * d)
	ray.force_raycast_update()
	return not ray.is_colliding()

func move(offset : Vector2i) -> void:
	is_moving = true
	var sprite_position : Vector2 = sprite.global_position
	var t : Tween = create_tween()
	t.tween_property(sprite, "position", Vector2.ZERO, 0.25)
	position += 24.0 * offset
	sprite.global_position = sprite_position
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	is_moving = false

func _physics_process(_delta: float) -> void:
	if freeze:
		return
	if (not is_moving) and timer and timer.time_left <= 0:
		var direction : Vector2 = Vector2.ZERO
		if randf() >= 0.5:
			direction.x = 1
		else:
			direction.y = 1
		if randf() >= 0.5:
			direction *= -1
		if direction.x < 0:
			sprite.flip_h = false
		elif direction.x > 0:
			sprite.flip_h = true
		if check_for_collision_by_ray(direction):
			timer.start(randf_range(0.5, 3.5))
			move(direction)
