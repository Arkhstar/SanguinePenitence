class_name BattleTimer
extends Node

signal pulse

static var i : BattleTimer

var tempo : float = 180.0 :
	get:
		return 60.0 / tempo
var time_left : float = 0.0
var slow_mode : bool = false

func resync() -> void:
	time_left = tempo

func _physics_process(delta: float) -> void:
	time_left -= (delta / 4.0 if slow_mode else delta)
	while time_left < 0:
		time_left += tempo
		pulse.emit()
		ATBTimerQTE.momentum -= 0.25

func _ready() -> void:
	i = self
