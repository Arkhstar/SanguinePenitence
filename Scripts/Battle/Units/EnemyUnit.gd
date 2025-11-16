class_name EnemyUnit
extends BattleUnit

enum TargetingType { RANDOM, LOW_HEALTH, HIGH_HEALTH, LOW_SHARPNESS, HIGH_SHARPNESS, LEAST_EFFECTS, MOST_EFFECTS }
@export var targeting : TargetingType = TargetingType.RANDOM

var next_target : int = -1

@export var grade : Inventory.MonsterPartGrade = Inventory.MonsterPartGrade.GRADE_D

func _init(dname : String = display_name, hp : int = health, strg : int = strength, def : int = defense, c_chance : float = crit_chance, c_dmg : float = crit_damage, spd : float = speed, trgt : TargetingType = targeting, grd : Inventory.MonsterPartGrade = grade) -> void:
	super(dname, hp, strg, def, c_chance, c_dmg, spd)
	targeting = trgt
	grade = grd

func clone() -> EnemyUnit:
	return EnemyUnit.new(display_name, max_health, strength, defense, crit_chance, crit_damage, speed, targeting)

func take_damage(amount : int) -> void:
	if ATBTimerQTE.momentum > 100.0:
		amount *= (1.1) ** ((ATBTimerQTE.momentum - 100.0) / 100.0)
	super(amount)

func find_target(player_units : Array[PlayerUnit]) -> int:
	if targeting == TargetingType.RANDOM:
		var idx : int = randi_range(0, 3)
		for i : int in 4:
			if player_units[(i + idx) % 4] and player_units[(i + idx) % 4].health > 0:
				return (i + idx) % 4
		return -1
	elif targeting == TargetingType.LOW_HEALTH:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].health < player_units[idx].health or (player_units[i].health == player_units[idx].health and randf() >= 0.5)):
				idx = i
		return idx
	elif targeting == TargetingType.HIGH_HEALTH:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].health > player_units[idx].health or (player_units[i].health == player_units[idx].health and randf() >= 0.5)):
				idx = i
		return idx
	elif targeting == TargetingType.LOW_SHARPNESS:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].sharpness < player_units[idx].sharpness or (player_units[i].sharpness == player_units[idx].sharpness and randf() >= 0.5)):
				idx = i
		return idx
	elif targeting == TargetingType.HIGH_SHARPNESS:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].sharpness > player_units[idx].sharpness or (player_units[i].sharpness == player_units[idx].sharpness and randf() >= 0.5)):
				idx = i
		return idx
	elif targeting == TargetingType.LEAST_EFFECTS:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].effects.count(0) > player_units[idx].count(0) or (player_units[i].count(0) == player_units[idx].count(0) and randf() >= 0.5)):
				idx = i
		return idx
	elif targeting == TargetingType.MOST_EFFECTS:
		var idx : int = 0
		for i : int in 4:
			if player_units[i] and player_units[i].health > 0 and (player_units[i].effects.count(0) < player_units[idx].count(0) or (player_units[i].count(0) == player_units[idx].count(0) and randf() >= 0.5)):
				idx = i
		return idx
	return -1

func is_hit(attacker : PlayerUnit, power : int, spell : int = -1) -> void:
	var damage : int = calculate_damage_taken(attacker, power)
	if spell < 0: # Basic Attack
		damage *= attacker.get_sharpness_damage_modifier()
		attacker.sharpness -= floori(defense / 2.0)
	else:
		determine_spell_effects(spell)
	print("Enemy %s took %d damage!" % [display_name, damage])
	take_damage(damage)

func determine_attack_hits(defender : BattleUnit) -> bool:
	return (randf_range(speed, speed * 2.0) - defender.speed / 8.0) / (speed) > 0 or randf() > 0.99
