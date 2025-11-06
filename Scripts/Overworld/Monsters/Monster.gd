class_name Monster
extends Area2D

@onready var initiate_combat_sfx : AudioStreamPlayer = $InitiateCombatSFX

func _on_area_entered(_body: Node2D) -> void:
	OverworldPlayer.i.ignore_input = true
	MusicStreamPlayer.adjust_volume(0.0, 1.0)
	initiate_combat_sfx.play()
	while initiate_combat_sfx.playing:
		await RenderingServer.frame_post_draw
	Main.i.call_deferred("change_to_battle_from_overworld", [ EnemyUnit.new("TEST CASE", 50, 12, 6, 0.0, 1.0, 1.0, EnemyUnit.TargetingType.LOW_HEALTH) ])
	queue_free()
