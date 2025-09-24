extends AnimatedSprite2D

@onready var selector : Sprite2D = $Selector
var in_range : bool = false
var client : Client = null :
	set(value):
		client = value
		selector.visible = client != null

func _on_area_2d_body_entered(_body: Node2D) -> void:
	in_range = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	in_range = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and in_range and client:
		play("default")
		client = null
