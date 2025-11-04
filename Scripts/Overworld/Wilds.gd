class_name Wilds
extends Node2D

func _ready() -> void:
	if MusicStreamPlayer.get_playing() != MusicStreamPlayer.Song.FOREST:
		MusicStreamPlayer.volume_linear = 0.0
		MusicStreamPlayer.play_music(MusicStreamPlayer.Song.FOREST)
		await MusicStreamPlayer.adjust_volume(1.0, 3.0)
