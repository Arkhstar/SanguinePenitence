class_name BattleMain
extends Node

enum VictoryState { INIT, UNDETERMINED, WIN, LOSE }
var victory_state : VictoryState = VictoryState.INIT :
	set(v):
		victory_state = v
		if v == VictoryState.LOSE:
			$LoseScreen.activate()
		elif v == VictoryState.WIN:
			SaveData.obols += randi_range(30, 150)
			Main.i.change_to_overworld_from_battle()

var units : Array[BattleUnit] = [ SaveData.hunter_unit, null, null, null, null, null, null, null ]
var timers : Array[ATBTimer] = [ null, null, null, null, null, null, null, null ]

@onready var player_displays : Array[PlayerBattleDisplay] = [ $PlayerDisplays/PlayerDisplay1, $PlayerDisplays/PlayerDisplay2, $PlayerDisplays/PlayerDisplay3, $PlayerDisplays/PlayerDisplay4 ]
@onready var enemy_displays : Array[EnemyBattleDisplay] = [ $EnemyDisplays/EnemyDisplay1, $EnemyDisplays/EnemyDisplay2, $EnemyDisplays/EnemyDisplay3, $EnemyDisplays/EnemyDisplay4 ]
@onready var selector : BattleSelector = $Selector
var selection : int = -1

@onready var menu : BattleMenu = $BattleMenu
var ready_to_act : PackedInt32Array = []
var acting : int = -1

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
	if index >= 4:
		if units[index].next_target >= 0:
			player_displays[units[index].next_target].cancel_targeted(index - 4)
		enemy_displays[index - 4].unit = null

func on_unit_revive(index : int) -> void:
	timers[index].allow_update = true
	if index >= 4:
		enemy_displays[index - 4].unit = units[index]

func on_atb_timeout(index : int) -> void:
	units[index].tick_effects()
	if units[index].health <= 0:
		return
	if index < 4:
		ready_to_act.append(index)
	else:
		enemy_ai(index)

func menu_selection(option : int) -> void:
	if option <= 1:
		if option == 1:
			if units[acting].reagent <= 0 or units[acting].effects[BattleUnit.StatusEffect.FAITHLESS] > 0:
				menu.fail_sfx.play()
				return
		menu.select_sfx.play()
		if [ units[4] and units[4].health > 0, units[5] and units[5].health > 0, units[6] and units[6].health > 0, units[7] and units[7].health > 0 ].filter(func(element : bool) -> bool: return element).size() > 1:
			selection = option
			await selector.set_targeting_enemies()
			selector.show()
			menu.ignore_input = true
			return
		else:
			for i : int in 4:
				if units[i + 4]:
					if units[acting].determine_attack_hits(units[i + 4]):
						print("Hit: %d" % (i + 4))
						units[i + 4].is_hit(units[acting], -1 if option == 0 else units[acting].reagent)
					else:
						print("MISS: %d" % (i + 4))
	elif option == 4:
		if [ units[0] and units[0].health > 0, units[1] and units[1].health > 0, units[2] and units[2].health > 0, units[3] and units[3].health > 0 ].filter(func(element : bool) -> bool: return element).size() > 1:
			menu.select_sfx.play()
			selection = option
			await selector.set_targeting_players()
			selector.show()
			menu.ignore_input = true
			return
		menu.fail_sfx.play()
		return
	else:
		if (units[acting].effects[BattleUnit.StatusEffect.GREED] <= 0) and (option != 3 or SaveData.inventory.consumables.count(0) < Inventory.ConsumableItem.size()) and (option != 2 or (SaveData.inventory.reagents.count(0) < Inventory.ReagentItem.size() or units[acting].effects[BattleUnit.StatusEffect.FAITHLESS] <= 0)):
			menu.select_sfx.play()
			#TODO: reagent / item was chosen
			return
		menu.fail_sfx.play()
		return
	
	menu.ignore_input = true
	menu.hide()
	timers[acting].reset(timers[acting].qte_step, [12.0, 16.0, 6.0, 6.0, 8.0][option]) # vary with selected option
	BattleTimer.i.paused = false
	acting = -1

func selector_selection(index : int) -> void:
	if index == -1:
		selector.ignore_input = true
		menu.ignore_input = false
		selector.hide()
	else:
		if selection <= 1:
			if units[acting].determine_attack_hits(units[index]):
				print("Hit: %d" % (index))
				units[index].is_hit(units[acting], -1 if selection == 0 else units[acting].reagent)
			else:
				print("MISS: %d" % (index))
		else:
			timers[index].value += units[acting].speed * 2.0
		selector.ignore_input = true
		menu.ignore_input = true
		selector.hide()
		menu.hide()
		timers[acting].reset(timers[acting].qte_step, [12.0, 16.0, 6.0, 6.0, 8.0][selection]) # vary with selected option
		BattleTimer.i.paused = false
		acting = -1

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

func init_combat(song : MusicStreamPlayer.Song = MusicStreamPlayer.Song.BATTLE) -> void:
	ATBTimerQTE.momentum = 0.0
	BattleTimer.i = BattleTimer.new()
	BattleTimer.i.tempo = {
		MusicStreamPlayer.Song.BATTLE : 180.0, # Wyrmchaser
		MusicStreamPlayer.Song.BATTLE2 : 327.2, # Dona eis Requiem
		MusicStreamPlayer.Song.BATTLE3 : 400.0 # 𝛂∧𝛚
	}[song]
	add_child(BattleTimer.i)
	init_enemies()
	init_players()
	MusicStreamPlayer.adjust_volume(1.0, 0.125)
	MusicStreamPlayer.play_music(song)
	BattleTimer.i.resync()
	for u : BattleUnit in units:
		if u:
			BattleTimer.i.pulse.connect(func() -> void:
				if u.effects[BattleUnit.StatusEffect.BURN] > 0:
					u.take_damage(randi_range(u.effects[BattleUnit.StatusEffect.BURN] / 4, u.effects[BattleUnit.StatusEffect.BURN]))
				return)
	BattleTimer.i.static_pulse.connect($PulseVFX.pulse)
	BattleTimer.i.static_pulse.connect(selector.pulse_anim)
	BattleTimer.i.static_pulse.connect($MetronomeVFX.pulse)
	selector.displays = [ player_displays[0], player_displays[1], player_displays[2], player_displays[3], enemy_displays[0], enemy_displays[1], enemy_displays[2], enemy_displays[3] ]
	victory_state = VictoryState.UNDETERMINED
	TransitionScreen.fade_out(0.25)

func _ready() -> void:
	menu.selection.connect(menu_selection)
	selector.selection.connect(selector_selection)

func _process(_delta: float) -> void:
	for display : PlayerBattleDisplay in player_displays:
		display.update()
	for display : EnemyBattleDisplay in enemy_displays:
		display.update()

func _physics_process(_delta: float) -> void:
	if victory_state == VictoryState.UNDETERMINED:
		var alive : Array[BattleUnit] = units.filter(func(element : BattleUnit) -> bool: return element and element.health > 0)
		if not alive.any(func(element : BattleUnit) -> bool: return element is EnemyUnit):
			victory_state = VictoryState.WIN
			BattleTimer.i.paused = true
			return
		if not alive.any(func(element : BattleUnit) -> bool: return element is PlayerUnit):
			victory_state = VictoryState.LOSE
			BattleTimer.i.paused = true
			return
	else:
		return
	if acting == -1 and ready_to_act.size() > 0:
		BattleTimer.i.paused = true
		acting = ready_to_act[0]
		ready_to_act.remove_at(0)
		menu.index = 0
		menu.update_availability(units[acting], [ units[0] and units[0].health > 0, units[1] and units[1].health > 0, units[2] and units[2].health > 0, units[3] and units[3].health > 0 ].filter(func(element : bool) -> bool: return element).size() > 1)
		menu.reparent(player_displays[acting], false)
		menu.show()
		menu.activate()
