class_name BattleTimer
extends Node

signal pulse
signal static_pulse

static var i : BattleTimer

var tempo : float = 180.0 :
	get:
		return 60.0 / tempo
var time_left : float = 0.0
var paused : bool = false

func resync() -> void:
	time_left = 0

func _physics_process(delta: float) -> void:
	time_left -= delta
	while time_left <= 0:
		time_left += tempo
		static_pulse.emit()
		if paused:
			return
		pulse.emit()
		ATBTimerQTE.momentum -= 0.25
