class_name PlayerUnit
extends BattleUnit

var sharpness : int

func _init(dname : String, hp : int, strg : int, def : int, c_chance : float, c_dmg : float, spd : float, shrp : int) -> void:
	super(dname, hp, strg, def, c_chance, c_dmg, spd)
	sharpness = shrp

func clone() -> PlayerUnit:
	return PlayerUnit.new(display_name, max_health, strength, defense, crit_chance, crit_damage, speed, sharpness)

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
