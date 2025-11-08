class_name BattleUnit
extends Resource

signal died
signal revived

@export var display_name : String = "UNIT NAME"
@export var max_health : int = 500
var health : int = 500 :
	set(v):
		if health <= 0 and v > 0:
			revived.emit()
		health = v
		if health <= 0:
			died.emit()
@export var strength : int = 5
@export var defense : int = 5
@export var crit_chance : float = 0.0
@export var crit_damage : float = 1.0
@export var speed : float = 1.0 :
	get:
		return speed / (effects[StatusEffect.HEAVY] + 1.0)

enum StatusEffect { BURN, BLEED, CURSE, GREED, FAITHLESS, HEAVY }
var effects : PackedInt32Array = [ 0, 0, 0, 0, 0, 0 ]

func _init(dname : String, hp : int, strg : int, def : int, c_chance : float, c_dmg : float, spd : float) -> void:
	display_name = dname
	max_health = hp
	health = hp
	strength = strg
	defense = def
	crit_chance = c_chance
	crit_damage = c_dmg
	speed = spd
	effects = [ 0, 0, 0, 0, 0, 0 ]

func calculate_damage_taken(attacker : BattleUnit, power : int = 0) -> int:
	var damage : int = maxi(randi_range(attacker.strength, attacker.strength * 2 + power) - defense, 1)
	if randf() < crit_chance:
		damage += floori((randi_range(attacker.strength, attacker.strength * 2) + power) * crit_damage)
	if effects[StatusEffect.CURSE] > 0:
		damage *= (effects[StatusEffect.CURSE] + 1)
	return damage

func determine_attack_hits(defender : BattleUnit) -> bool:
	return (randf_range(speed, speed * 2.0) - defender.speed * 8) / (speed) > 0 or randf() > 0.99

func take_damage(amount : int) -> void:
	health = move_toward(health, 0, amount)

func apply_effect(effect : StatusEffect, stacks : int) -> void:
	effects[effect] += stacks

func tick_effects() -> void:
	if effects[StatusEffect.BLEED] > 0:
		take_damage(randi_range(effects[StatusEffect.BLEED], effects[StatusEffect.BLEED] * 3))
	for effect : StatusEffect in [ StatusEffect.BURN, StatusEffect.CURSE, StatusEffect.HEAVY ]:
		effects[effect] = maxi(effects[effect] - 1, 0)
	for effect : StatusEffect in [ StatusEffect.BLEED, StatusEffect.GREED, StatusEffect.FAITHLESS ]:
		effects[effect] = maxi(effects[effect] / 2, 0)

func determine_spell_effects(spell_id : int) -> void:
	print(spell_id) #TODO
