class_name Town
extends Node2D

func _ready() -> void:
	if SaveData.altar_level <= 0:
		MusicStreamPlayer.volume_linear = 0.0
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TOWN)
