class_name Wilds
extends Node2D

func _enter_tree() -> void:
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.FOREST)
