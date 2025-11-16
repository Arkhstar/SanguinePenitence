class_name Inventory
extends Resource

enum MonsterPartGrade { GRADE_S, GRADE_A, GRADE_B, GRADE_C, GRADE_D }
var monster_parts : PackedInt32Array = []
var gathered_monster_parts : PackedInt32Array = []

enum ReagentItem { FIREBALL }
var reagents : PackedInt32Array = []

enum ConsumableItem { TEMP }
var consumables : PackedInt32Array = []

func _init() -> void:
	monster_parts = PackedInt32Array()
	monster_parts.resize(MonsterPartGrade.size())
	gathered_monster_parts = PackedInt32Array()
	gathered_monster_parts.resize(MonsterPartGrade.size())
	reagents = PackedInt32Array()
	reagents.resize(ReagentItem.size())
	consumables = PackedInt32Array()
	consumables.resize(ConsumableItem.size())

func obtain_monster_parts() -> void:
	for i : int in MonsterPartGrade.size():
		monster_parts[i] += gathered_monster_parts[i]
		gathered_monster_parts[i] = 0

func lose_monster_parts() -> void:
	for i : int in MonsterPartGrade.size():
		gathered_monster_parts[i] = 0

func to_str() -> String:
	var dict : Dictionary = {
		"qrry" : monster_parts,
		"rgnt" : reagents,
		"cmbl" : consumables
	}
	return JSON.stringify(dict)

static func from_str(data_str : String) -> Inventory:
	var inv : Inventory = Inventory.new()
	var json : JSON = JSON.new()
	if json.parse(data_str) == OK:
		var data : Variant = json.data
		if data is Dictionary:
			inv.monster_parts = data["qrry"]
			inv.reagents = data["rgnt"]
			inv.consumables = data["cmbl"]
	return inv
