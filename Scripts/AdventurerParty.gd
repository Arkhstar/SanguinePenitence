class_name AdventurerParty
extends Resource

var _leader : Adventurer = null
var _member1 : Adventurer = null
var _member2 : Adventurer = null
var _member3 : Adventurer = null

func _init(a0 : Adventurer, a1 : Adventurer, a2 : Adventurer = null, a3 : Adventurer = null) -> void:
	_leader = a0
	_member1 = a1
	_member2 = a2
	_member3 = a3
	if a3 != null and a2 == null:
		_member2 = a3
		_member3 = null

func _calculate_cumulative_stat(w : int, x : int, y : int, z : int) -> int:
	if y < 0:
		return w * 0.6 + x * 0.4
	elif z < 0:
		return w * 0.376 + x * 0.312 + y * 0.312
	return w * 0.301 + x * 0.233 + y * 0.233 + z * 0.233

func get_cumulative_strength() -> int:
	return _calculate_cumulative_stat(_leader.get_strength(), _member1.get_strength(), _member2.get_strength() if _member2 else -1, _member3.get_strength() if _member3 else -1)

func get_cumulative_intelligence() -> int:
	return _calculate_cumulative_stat(_leader.get_intelligence(), _member1.get_intelligence(), _member2.get_intelligence() if _member2 else -1, _member3.get_intelligence() if _member3 else -1)

func get_cumulative_faith() -> int:
	return _calculate_cumulative_stat(_leader.get_faith(), _member1.get_faith(), _member2.get_faith() if _member2 else -1, _member3.get_faith() if _member3 else -1)

func get_cumulative_will() -> int:
	return _calculate_cumulative_stat(_leader.get_will(), _member1.get_will(), _member2.get_will() if _member2 else -1, _member3.get_will() if _member3 else -1)

func get_cumulative_rank() -> int:
	var stats_mean : int = (get_cumulative_strength() + get_cumulative_intelligence() + get_cumulative_faith() + get_cumulative_will()) / 4
	if stats_mean > 0x40:
		return 3
	if stats_mean > 0x10:
		return 2
	if stats_mean > 0x04:
		return 1
	return 0

func get_leader() -> Adventurer:
	return _leader

func get_member1() -> Adventurer:
	return _member1

func get_member2() -> Adventurer:
	return _member2

func get_member3() -> Adventurer:
	return _member3

func get_party_size() -> int:
	if _member2:
		return 3
	elif _member3:
		return 4
	return 2
