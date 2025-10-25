class_name BattleMain
extends Node

var units : Array[BattleUnit] = [ PlayerUnit.new(), null, PlayerUnit.new(), null, null, EnemyUnit.new(), null, null ]
var timers : Array[ATBTimer] = [ null, null, null, null, null, null, null, null ]

func enemy_ai(acting_index : int) -> void:
	var target : int = await (units[acting_index] as EnemyUnit).attempt_attack([ units[0], units[1], units[2], units[3] ])
	if target >= 0:
		print("Hit: %d" % target)
		units[target].do_hit(units[acting_index], 0) #TODO: make variable attack type & power
	elif target >= -4:
		print("MISS: %d" % -(target + 1))

func on_atb_timeout(index : int) -> void:
	print(index)
	if index < 4:
		BattleTimer.i.slow_mode = true
		BattleTimer.i.slow_mode = false #TODO
	else:
		enemy_ai(index)
	timers[index].reset()

func init_player_timers() -> void:
	for i : int in 4:
		if units[i]:
			timers[i] = ATBTimerQTE.new()
			(timers[i] as ATBTimerQTE).qte_step = units[i].speed
			timers[i].step = 0.25
			timers[i].maximum = randf_range(4.0, 8.0)
			timers[i].timeout.connect(on_atb_timeout.bind(i))
			add_child(timers[i])

func init_enemy_timers() -> void:
	for i : int in 4:
		if units[i + 4]:
			timers[i + 4] = ATBTimer.new()
			timers[i + 4].step = units[i + 4].speed
			timers[i + 4].maximum = randf_range(8.0, 16.0)
			timers[i + 4].timeout.connect(on_atb_timeout.bind(i + 4))
			add_child(timers[i + 4])

func init_combat() -> void:
	BattleTimer.i = BattleTimer.new()
	add_child(BattleTimer.i)
	init_player_timers()
	init_enemy_timers()
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.BATTLE)
	BattleTimer.i.resync()

func _ready() -> void:
	init_combat()
