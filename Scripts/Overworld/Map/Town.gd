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
	if SaveData.merc_0 and SaveData.merc_0.health <= 0:
		SaveData.merc_0 = null
	if SaveData.merc_1 and SaveData.merc_1.health <= 0:
		SaveData.merc_1 = null
	if SaveData.merc_2 and SaveData.merc_2.health <= 0:
		SaveData.merc_2 = null
	SaveData.write_save_file()
