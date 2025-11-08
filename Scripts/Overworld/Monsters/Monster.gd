class_name Monster
extends Area2D

@export var encounter : Array[Array] = []
@export var theme : MusicStreamPlayer.Song = MusicStreamPlayer.Song.BATTLE
@onready var initiate_combat_sfx : AudioStreamPlayer = $InitiateCombatSFX

func _on_area_entered(_body: Node2D) -> void:
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
	Main.i.call_deferred("change_to_battle_from_overworld", encounter.pick_random(), theme)
	queue_free()
