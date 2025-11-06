class_name Inventory
extends Resource

enum MonsterPartGrade { GRADE_S, GRADE_A, GRADE_B, GRADE_C, GRADE_D }
var monster_parts : PackedInt32Array = []
var gathered_monster_parts : PackedInt32Array = []

var reagents : PackedInt32Array = []

func _init() -> void:
	monster_parts = PackedInt32Array()
	monster_parts.resize(MonsterPartGrade.size())
	gathered_monster_parts = PackedInt32Array()
	gathered_monster_parts.resize(MonsterPartGrade.size())

func obtain_monster_parts() -> void:
	for i : int in MonsterPartGrade.size():
		monster_parts[i] += gathered_monster_parts[i]
		gathered_monster_parts[i] = 0

func lose_monster_parts() -> void:
	for i : int in MonsterPartGrade.size():
		gathered_monster_parts[i] = 0
