class_name NPC
extends StaticBody2D

@export var menu : NPCMenu
@onready var area : Area2D = $InteractArea
@onready var prompt : Sprite2D = $Prompt

func _ready() -> void:
	area.body_entered.connect(_on_area_entered)
	area.body_exited.connect(_on_area_exited)

func _on_area_entered(_body: Node2D) -> void:
	prompt.show()

func _on_area_exited(_body: Node2D) -> void:
	prompt.hide()

func on_interact() -> void:
	if OverworldPlayer.i.is_moving or OverworldPlayer.i.ignore_input:
		return
	if menu:
		menu.open()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and prompt.visible:
		on_interact()
