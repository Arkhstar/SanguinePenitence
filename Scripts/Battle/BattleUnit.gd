class_name BattleUnit
extends Resource

var display_name : String
var max_health : int
var health : int = 100 :
	set(v):
		print("HEALTH : %d-%d" % [health, v])
		health = v
var strength : int = 1
var defense : int
var crit_chance : float
var crit_damage : float
var speed : float = 1.0 :
	get:
		return speed / (effects[StatusEffect.HEAVY] + 1)

enum StatusEffect { BURN, BLEED, CURSE, GREED, FAITHLESS, HEAVY }
var effects : PackedInt32Array = [ 0, 0, 0, 0, 0, 0 ]

func calculate_damage_taken(attacker : BattleUnit, power : int = 0) -> int:
	var damage : int = maxi(randi_range(attacker.strength, attacker.strength * 2 + power) - defense, 0)
	if randf() < crit_chance:
		damage += floori((randi_range(attacker.strength, attacker.strength * 2) + power) * crit_damage)
	if effects[StatusEffect.CURSE] > 0:
		if damage == 0:
			damage = 1
		damage *= (effects[StatusEffect.CURSE] + 1)
	return damage

func determine_attack_hits(defender : BattleUnit) -> bool:
	return (randf_range(speed, speed * 2.0) - defender.speed) / (speed) > 0 or randf() > 0.99

func take_damage(amount : int) -> void:
	health = move_toward(health, 0, amount)

func apply_effect(effect : StatusEffect, stacks : int) -> void:
	effects[effect] += stacks

func tick_effects() -> void:
	if effects[StatusEffect.BURN] > 0:
		take_damage(randi_range(effects[StatusEffect.BURN], effects[StatusEffect.BURN] * 5))
	for effect : StatusEffect in [ StatusEffect.BURN, StatusEffect.CURSE, StatusEffect.HEAVY ]:
		effects[effect] = maxi(effects[effect] - 1, 0)
	for effect : StatusEffect in [ StatusEffect.BLEED, StatusEffect.GREED, StatusEffect.FAITHLESS ]:
		effects[effect] = maxi(effects[effect] / 2, 0)

func determine_spell_effects(spell_id : int) -> void:
	print(spell_id) #TODO
