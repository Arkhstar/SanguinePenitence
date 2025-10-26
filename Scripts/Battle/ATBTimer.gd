class_name ATBTimer
extends Node

signal timeout

var allow_update : bool = true

var maximum : float = 4.0
var step : float = 1.0
var value : float = 0.0

func reset(s : float = step, m : float = maximum) -> void:
	step = s
	maximum = m
	value = 0

func on_pulse() -> void:
	if allow_update:
		value = move_toward(value, maximum, step)
		if value == maximum:
			timeout.emit()

func _ready() -> void:
	BattleTimer.i.pulse.connect(on_pulse)
