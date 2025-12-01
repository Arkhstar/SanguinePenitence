class_name Town
extends Node2D

@onready var oracle : NPC = $Oracle
@onready var smith : NPC = $Smith
@onready var butcher : NPC = $Butcher

func _ready() -> void:
	if SaveData.highest_altar_level <= 50:
		smith.queue_free()
	if SaveData.altar_level <= 0:
		MusicStreamPlayer.volume_linear = 0.0

func _enter_tree() -> void:
	if Wilds.time > 0:
		SaveData.altar_level = max(SaveData.altar_level - roundi(Wilds.time / 30.0), 1)
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TOWN)
	SaveData.inventory.obtain_monster_parts()
	SaveData.write_save_file()
