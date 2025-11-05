class_name Main
extends Node

func _ready() -> void:
	SaveData.load_defaults()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Overworld/town.tscn")
