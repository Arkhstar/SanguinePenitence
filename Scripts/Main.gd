class_name Main
extends Node

static var i : Main
var current : Node = null
var last : Node = null

func _ready() -> void:
	i = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	call_deferred("load_title")

func load_title() -> void:
	await TransitionScreen.fade_in(0)
	var title : MainMenu = preload("res://Scenes/main_menu.tscn").instantiate()
	current = title
	add_child(title)
	MusicStreamPlayer.volume_linear = 0.0
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.TITLE)
	MusicStreamPlayer.adjust_volume(1.0, 3.0)
	await TransitionScreen.fade_out()
	title.ignore_input = false

func quit_to_title() -> void:
	MusicStreamPlayer.adjust_volume(0.0, 0.5)
	await TransitionScreen.fade_in()
	last = null
	await load_title()

func change_scene(file_name : String, in_vol : float = 1.0) -> void:
	MusicStreamPlayer.adjust_volume(0.0, 0.5)
	await TransitionScreen.fade_in()
	last = current
	if last:
		remove_child(last)
	var scene : Node = load(file_name).instantiate()
	current = scene
	add_child(current)
	MusicStreamPlayer.adjust_volume(in_vol, 0.5)
	await TransitionScreen.fade_out()

func change_to_battle_from_overworld(encounter : Array, song : MusicStreamPlayer.Song = MusicStreamPlayer.Song.BATTLE) -> void:
	last = current
	remove_child(last)
	var scene : BattleMain = preload("res://Scenes/Battle/battle_main.tscn").instantiate()
	current = scene
	add_child(current)
	for idx : int in mini(encounter.size(), 4):
		if encounter[idx]:
			scene.units[idx + 4] = encounter[idx].clone()
	scene.init_combat(song)

func change_to_overworld_from_battle() -> void:
	MusicStreamPlayer.adjust_volume(0.0, 0.5)
	await TransitionScreen.fade_in()
	remove_child(current)
	add_child(last)
	current = last
	OverworldPlayer.i.cam.rotation = 0.0;
	OverworldPlayer.i.cam.zoom = Vector2(1.0, 1.0);
	last = null
	MusicStreamPlayer.adjust_volume(1.0, 0.5)
	await TransitionScreen.fade_out()
	OverworldPlayer.i.ignore_input = false

func die() -> void:
	SaveData.inventory.lose_monster_parts()
	SaveData.hunter_unit.health = SaveData.hunter_unit.max_health / 2
	SaveData.hunter_unit.sharpness -= 30
	change_scene("res://Scenes/Overworld/town.tscn")
	last = null
