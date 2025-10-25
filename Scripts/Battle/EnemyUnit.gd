class_name EnemyUnit
extends BattleUnit

enum TargetingType { RANDOM, LOW_HEALTH, HIGH_HEALTH, LOW_SHARPNESS, HIGH_SHARPNESS, LEAST_EFFECTS, MOST_EFFECTS }
var targeting : TargetingType = TargetingType.RANDOM

func find_target(player_units : Array[PlayerUnit]) -> int:
	if targeting == TargetingType.RANDOM:
		var idx : int = randi_range(0, 3)
		while (not player_units[idx]) or player_units[idx].health <= 0:
			idx = (idx + 1) % 4
			await RenderingServer.frame_pre_draw
		return idx
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

func attempt_attack(player_units : Array[PlayerUnit]) -> int:
	var target_index : int = await find_target(player_units)
	if target_index >= 0 and target_index < 4:
		if determine_attack_hits(player_units[target_index]):
			return target_index
		return -(target_index + 1)
	return -5

func do_hit(attacker : PlayerUnit, power : int, spell : int = -1) -> void:
	var damage : int = calculate_damage_taken(attacker, power)
	if spell < 0: # Basic Attack
		damage *= attacker.get_sharpness_damage_modifier()
		attacker.sharpness -= floori(defense / 2.0)
	else:
		determine_spell_effects(spell)
	print("%s took %d damage!" % [display_name, damage])
	take_damage(damage)
