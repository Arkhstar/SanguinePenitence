class_name PlayerUnit
extends Resource

var dname : String
var texture : Texture2D

var max_health : int :
	set(v):
		max_health = clampi(v, 1, 999999)
var health : int :
	set(v):
		health = clampi(v, 0, max_health)
var strength : int :
	set(v):
		strength = clampi(v, 1, 99999)
var sharpness : int :
	set(v):
		sharpness = clampi(v, 0, 150)
var speed : int :
	set(v):
		speed = clampi(v, 0, 99)

var reagent : int

var status : int

func calculate_damage_taken(enemy : EnemyUnit) -> int:
	return maxi(randi_range(enemy.strength, 2 * enemy.strength) - strength + 1, 0)
