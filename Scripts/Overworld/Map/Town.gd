class_name Town
extends Node2D

@onready var oracle : NPC = $Oracle

func _ready() -> void:
	if SaveData.highest_altar_level <= 0:
		oracle.queue_free()
	if SaveData.altar_level <= 0:
		MusicStreamPlayer.volume_linear = 0.0

func _enter_tree() -> void:
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TOWN)
	SaveData.inventory.obtain_monster_parts()
	SaveData.write_save_file()
