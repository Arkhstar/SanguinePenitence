class_name BattleMain
extends Node

var units : Array[BattleUnit] = [ PlayerUnit.new(), PlayerUnit.new(), PlayerUnit.new(), PlayerUnit.new(), EnemyUnit.new(), EnemyUnit.new(), EnemyUnit.new(), EnemyUnit.new() ]
var timers : Array[ATBTimer] = [ null, null, null, null, null, null, null, null ]

@onready var player_displays : Array[PlayerBattleDisplay] = [ $PlayerDisplays/PlayerDisplay1, $PlayerDisplays/PlayerDisplay2, $PlayerDisplays/PlayerDisplay3, $PlayerDisplays/PlayerDisplay4 ]
@onready var enemy_displays : Array[EnemyBattleDisplay] = [ $EnemyDisplays/EnemyDisplay1, $EnemyDisplays/EnemyDisplay2, $EnemyDisplays/EnemyDisplay3, $EnemyDisplays/EnemyDisplay4 ]

@onready var menu : BattleMenu = $BattleMenu

func enemy_ai(acting_index : int) -> void:
	var actor : EnemyUnit = units[acting_index]
	var player_units : Array[PlayerUnit] = [ units[0], units[1], units[2], units[3] ]
	
	var timer_max : float = randf_range(8.0, 16.0) #TODO: Vary with chosen attack
	
	if actor.next_target >= 0 and actor.next_target < 4:
		player_displays[actor.next_target].release_targeted(acting_index - 4)
		if actor.determine_attack_hits(units[actor.next_target]):
			print("Hit: %d" % actor.next_target)
			units[actor.next_target].is_hit(actor, 0) #TODO: make variable attack type & power
		else:
			print("MISS: %d" % actor.next_target)
	
	var next_target : int = actor.find_target(player_units)
	actor.next_target = next_target
	if next_target >= 0 and next_target < 4:
		player_displays[next_target].set_targeted(acting_index - 4)
	
	timers[acting_index].reset(timers[acting_index].step, timer_max)

func on_unit_death(index : int) -> void:
	timers[index].allow_update = false
	timers[index].reset()
	for i : int in 6:
		units[index].effects[i] = 0
	if index >= 4 and units[index].next_target >= 0:
		player_displays[units[index].next_target].cancel_targeted(index - 4)

func on_unit_revive(index : int) -> void:
	timers[index].allow_update = true

func on_atb_timeout(index : int) -> void:
	print(index)
	units[index].tick_effects()
	if units[index].health <= 0:
		return
	if index < 4:
		BattleTimer.i.slow_mode = true
		menu.reparent(player_displays[index])
		menu.show()
		menu.ignore_input = false
		#TODO
		#BattleTimer.i.slow_mode = false
		#timers[index].reset()
	else:
		enemy_ai(index)

func menu_selection(option : int) -> void:
	print("OPTION %d" % option)

func init_players() -> void:
	for i : int in 4:
		player_displays[i].unit = units[i]
		player_displays[i].hide_indicators([ not units[4] == null, not units[5] == null, not units[6] == null, not units[7] == null ])
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
			timers[i + 4].maximum = randf_range(2.0, 4.0)
			timers[i + 4].timeout.connect(on_atb_timeout.bind(i + 4))
			units[i + 4].died.connect(on_unit_death.bind(i + 4))
			add_child(timers[i + 4])

func init_combat() -> void:
	ATBTimerQTE.momentum = 0.0
	BattleTimer.i = BattleTimer.new()
	add_child(BattleTimer.i)
	init_enemies()
	init_players()
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.BATTLE)
	BattleTimer.i.resync()
	BattleTimer.i.pulse.connect($PulseVFX.pulse)

func _ready() -> void:
	menu.selection.connect(menu_selection)
	init_combat()

func _process(_delta: float) -> void:
	for display : PlayerBattleDisplay in player_displays:
		display.update()
	for display : EnemyBattleDisplay in enemy_displays:
		display.update()
