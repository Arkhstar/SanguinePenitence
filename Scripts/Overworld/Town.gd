class_name Town
extends Node2D

@onready var oracle : NPC = $Oracle

func _ready() -> void:
	if SaveData.highest_altar_level <= 0:
		oracle.queue_free()
	if SaveData.altar_level <= 0:
		MusicStreamPlayer.volume_linear = 0.0
		MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TOWN)
	elif MusicStreamPlayer.get_playing() != MusicStreamPlayer.Song.TOWN:
		MusicStreamPlayer.volume_linear = 0.0
		MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TOWN)
		await MusicStreamPlayer.adjust_volume(1.0, 3.0)
