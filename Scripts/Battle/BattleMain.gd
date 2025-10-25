class_name BattleMain
extends Node

var units : Array[BattleUnit] = [ BattleUnit.new(), null, BattleUnit.new(), null, null, BattleUnit.new(), null, null ]
var timers : Array[ATBTimer] = [ null, null, null, null, null, null, null, null ]

func on_atb_timeout(index : int) -> void:
	print(index)
	if index < 4:
		BattleTimer.i.slow_mode = true
		BattleTimer.i.slow_mode = false #TODO
	timers[index].reset()

func _ready() -> void:
	BattleTimer.i = BattleTimer.new()
	add_child(BattleTimer.i)
	for i : int in 4:
		if units[i]:
			timers[i] = ATBTimerQTE.new()
			(timers[i] as ATBTimerQTE).qte_step = units[i].speed
			timers[i].step = 0.25
			timers[i].maximum = randf_range(4.0, 8.0)
			timers[i].timeout.connect(on_atb_timeout.bind(i))
			add_child(timers[i])
	for i : int in 4:
		if units[i + 4]:
			timers[i + 4] = ATBTimer.new()
			timers[i + 4].step = units[i + 4].speed
			timers[i + 4].maximum = randf_range(8.0, 16.0)
			timers[i + 4].timeout.connect(on_atb_timeout.bind(i + 4))
			add_child(timers[i + 4])
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.BATTLE)
	BattleTimer.i.resync()
