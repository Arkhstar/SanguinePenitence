class_name Monster
extends Area2D

func _on_area_entered(_body: Node2D) -> void:
	Main.i.call_deferred("change_to_battle_from_overworld", [ EnemyUnit.new("TEST CASE", 50, 12, 6, 0.0, 1.0, 1.0, EnemyUnit.TargetingType.LOW_HEALTH) ])
	queue_free()
