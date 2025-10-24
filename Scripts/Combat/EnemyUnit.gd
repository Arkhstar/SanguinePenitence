class_name EnemyUnit
extends Resource

var dname : String
var texture : Texture2D

var health : int :
	set(v):
		health = clampi(v, 0, 999999)
var strength : int :
	set(v):
		strength = clampi(v, 1, 99999)
var speed : int :
	set(v):
		speed = clampi(v, 0, 99)

func calculate_damage_taken(player : PlayerUnit) -> int:
	return maxi(roundi(randi_range(player.strength, 2 * player.strength) * (player.sharpness / 100.0)) - strength + 1, 0)
