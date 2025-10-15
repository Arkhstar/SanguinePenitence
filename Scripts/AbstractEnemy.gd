#@abstract
class_name AbstractEnemy
extends Node2D

var health : int

func on_hit(damage : int, _from_spell : bool) -> void:
	print("%s took %d damage"%[name,damage])
	return
