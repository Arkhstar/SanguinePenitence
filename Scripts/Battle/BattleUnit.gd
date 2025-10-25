class_name BattleUnit
extends Resource

var display_name : String
var max_health : int
var health : int
var strength : int
var defense : int
var crit_chance : float
var crit_damage : float
var speed : float = 1.0

func calculate_damage_taken(attacker : BattleUnit, power : int = 0) -> int:
	var damage : int = maxi(randi_range(attacker.strength, attacker.strength * 2 + power) - defense, 0)
	if randf() < crit_chance:
		damage += floori((randi_range(attacker.strength, attacker.strength * 2) + power) * crit_damage)
	return damage
