class_name BattleSelector
extends TextureRect

var displays : Array[Control] = []

var ignore_input : bool = true
var idx : int = 0
var player : bool = false

func set_targeting_players() -> void:
	idx = 0
	player = true
	ignore_input = false

func set_targeting_enemies() -> void:
	idx = 0
	player = false
	ignore_input = false

func set_target_player(i : int) -> void:
	global_position = displays[i].global_position + Vector2(52.0, -18.0)
	flip_v = true

func set_target_enemy(i : int) -> void:
	global_position = displays[i + 4].global_position + Vector2(52.0, 37.0)
	flip_v = false

func pulse_anim() -> void:
	flip_h = not flip_h
