class_name Wilds
extends Node2D

static var time : float = 0.0

func _enter_tree() -> void:
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.FOREST)

func _physics_process(delta: float) -> void:
	time = max(time + delta, time)
