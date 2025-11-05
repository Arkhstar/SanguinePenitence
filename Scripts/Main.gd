class_name Main
extends Node

static var i : Main
var current : Node = null
var last : Node = null

func _ready() -> void:
	i = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	SaveData.load_defaults()
	call_deferred("change_scene", "res://Scenes/Overworld/town.tscn")

func change_scene(file_name : String) -> void:
	last = current
	if last:
		remove_child(last)
	var scene : Node = load(file_name).instantiate()
	current = scene
	add_child(current)

func change_to_battle_from_overworld(encounter : Array, song : MusicStreamPlayer.Song = MusicStreamPlayer.Song.BATTLE) -> void:
	last = current
	remove_child(last)
	var scene : Node = preload("res://Scenes/Battle/battle_main.tscn").instantiate()
	current = scene
	add_child(current)
	for idx : int in mini(encounter.size(), 4):
		(current as BattleMain).units[idx + 4] = encounter[idx].clone()
	(current as BattleMain).init_combat(song)

func change_to_overworld_from_battle() -> void:
	remove_child(current)
	add_child(last)
	current = last
	last = null
