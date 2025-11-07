class_name PlayerUnit
extends BattleUnit

var sharpness : int
var reagent : int

func _init(dname : String, mhp : int, hp : int, strg : int, def : int, c_chance : float, c_dmg : float, spd : float, shrp : int, rgt : int = 0) -> void:
	super(dname, mhp, strg, def, c_chance, c_dmg, spd)
	health = hp
	sharpness = shrp
	reagent = rgt

func clone() -> PlayerUnit:
	return PlayerUnit.new(display_name, max_health, health, strength, defense, crit_chance, crit_damage, speed, sharpness)

func get_sharpness_rank() -> int:
	if sharpness >= 250:
		return 0x53
	elif sharpness >= 175:
		return 0x41
	elif sharpness >= 100:
		return 0x42
	elif sharpness >= 50:
		return 0x43
	elif sharpness >= 0:
		return 0x44
	return 0x46

func sharpness_rank_as_char() -> String:
	return char(get_sharpness_rank())

func get_sharpness_damage_modifier() -> float:
	var rank : int = get_sharpness_rank()
	if rank == 0x53:
		return 3.0
	elif rank == 0x41:
		return 1.5
	elif rank == 0x42:
		return 1.25
	elif rank == 0x43:
		return 1.0
	elif rank == 0x44:
		return 0.5
	return 0.25

func is_hit(attacker : EnemyUnit, power : int, spell : int = -1) -> void:
	var damage : int = calculate_damage_taken(attacker, power)
	if spell >= 0:
		determine_spell_effects(spell)
	print("Player %s took %d damage!" % [display_name, damage])
	take_damage(damage)

func to_str() -> String:
	var dict : Dictionary = {
		"name" : display_name,
		"mxhp" : max_health,
		"hits" : health,
		"strn" : strength,
		"defn" : defense,
		"crtc" : crit_chance,
		"crtm" : crit_damage,
		"sped" : speed,
		"shrp" : sharpness,
		"rgnt" : reagent
	}
	return JSON.stringify(dict)

static func from_str(data_str : String) -> PlayerUnit:
	var json : JSON = JSON.new()
	if json.parse(data_str) == OK:
		var data : Variant = json.data
		if data is Dictionary:
			return PlayerUnit.new(
				data["name"],
				data["mxhp"],
				data["hits"],
				data["strn"],
				data["defn"],
				data["crtc"],
				data["crtm"],
				data["sped"],
				data["shrp"],
				data["rgnt"]
			)
	return PlayerUnit.new("MISSINGDATA", 100, 100, 10, 10, 0.01, 1.5, 10, 99)
