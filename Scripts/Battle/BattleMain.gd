class_name BattleMain
extends Node

var units : Array[BattleUnit] = [ PlayerUnit.new(), null, null, null, null, EnemyUnit.new(), null, null ]
var timers : Array[ATBTimer] = [ null, null, null, null, null, null, null, null ]

@onready var player_displays : Array[PlayerBattleDisplay] = [ $PlayerDisplays/PlayerDisplay1, $PlayerDisplays/PlayerDisplay2, $PlayerDisplays/PlayerDisplay3, $PlayerDisplays/PlayerDisplay4 ]
@onready var enemy_displays : Array[EnemyBattleDisplay] = [ $EnemyDisplays/EnemyDisplay1, $EnemyDisplays/EnemyDisplay2, $EnemyDisplays/EnemyDisplay3, $EnemyDisplays/EnemyDisplay4 ]

func enemy_ai(acting_index : int) -> void:
	var target : int = await (units[acting_index] as EnemyUnit).attempt_attack([ units[0], units[1], units[2], units[3] ])
	if target >= 0:
		print("Hit: %d" % target)
		units[target].is_hit(units[acting_index], 0) #TODO: make variable attack type & power
	elif target >= -4:
		print("MISS: %d" % -(target + 1))

func on_unit_death(index : int) -> void:
	timers[index].allow_update = false
	timers[index].reset()
	for i : int in 6:
		units[index].effects[i] = 0
	await get_tree().create_timer(1.0).timeout
	units[index].health = units[index].max_health

func on_unit_revive(index : int) -> void:
	timers[index].allow_update = true

func on_atb_timeout(index : int) -> void:
	print(index)
	units[index].tick_effects()
	if units[index].health <= 0:
		return
	if index < 4:
		BattleTimer.i.slow_mode = true
		BattleTimer.i.slow_mode = false #TODO
	else:
		enemy_ai(index)
	timers[index].reset()

func init_players() -> void:
	for i : int in 4:
		player_displays[i].unit = units[i]
		if units[i]:
			timers[i] = ATBTimerQTE.new()
			(timers[i] as ATBTimerQTE).qte_step = units[i].speed
			timers[i].step = 0.05
			timers[i].maximum = randf_range(4.0, 8.0)
			timers[i].timeout.connect(on_atb_timeout.bind(i))
			units[i].died.connect(on_unit_death.bind(i))
			units[i].revived.connect(on_unit_revive.bind(i))
			add_child(timers[i])
		player_displays[i].atb = timers[i]

func init_enemies() -> void:
	for i : int in 4:
		enemy_displays[i].unit = units[i + 4]
		if units[i + 4]:
			timers[i + 4] = ATBTimer.new()
			timers[i + 4].step = units[i + 4].speed
			timers[i + 4].maximum = randf_range(8.0, 16.0)
			timers[i + 4].timeout.connect(on_atb_timeout.bind(i + 4))
			units[i + 4].died.connect(on_unit_death.bind(i + 4))
			add_child(timers[i + 4])

func init_combat() -> void:
	ATBTimerQTE.momentum = 0.0
	BattleTimer.i = BattleTimer.new()
	add_child(BattleTimer.i)
	init_players()
	init_enemies()
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.BATTLE)
	BattleTimer.i.resync()
	BattleTimer.i.pulse.connect($PulseVFX.pulse)

func _ready() -> void:
	init_combat()

func _process(_delta: float) -> void:
	for display : PlayerBattleDisplay in player_displays:
		display.update()
	for display : EnemyBattleDisplay in enemy_displays:
		display.update()
