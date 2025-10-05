class_name HireAdventurerDialog
extends NinePatchRect

@onready var _y : Button = $Accept
@onready var _n : Button = $Decline

func disable_yes() -> void:
	_y.disabled = true

func disable_no() -> void:
	_n.disabled = true

func connect_yes_pressed(callable : Callable) -> void:
	_y.connect("button_down", callable)

func connect_no_pressed(callable : Callable) -> void:
	_n.connect("button_down", callable)
