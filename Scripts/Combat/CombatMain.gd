class_name CombatMain
extends Control

var state : int = 0 :
	set(v):
		state = v
		if state > 0:
			_enemy_cycle_timer.start(2.0)
			while _enemy_cycle_timer.time_left > 0:
				await RenderingServer.frame_post_draw
			print("VICTORY")
		elif state < 0:
			_enemy_cycle_timer.start(1.0)
			while _enemy_cycle_timer.time_left > 0:
				await RenderingServer.frame_post_draw
			print("FAILURE")

@onready var _enemy_combat_huds : Array[EnemyCHUD] = [ $"Enemy/0", $"Enemy/1", $"Enemy/2", $"Enemy/3" ]
@onready var _player_combat_huds : Array[PlayerCHUD] = [ $"Player/0", $"Player/1", $"Player/2", $"Player/3" ]
@onready var _menu : CombatMenu = $CombatMenu

var _enemy_units : Array[EnemyUnit] = [ null, null, null, null ]
var _player_units : Array[PlayerUnit] = [ null, null, null, null ]

var run_timers : bool = false
var _actor_timers : PackedFloat32Array = [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
var _timer_qte : int = 0b100100100100
var _acting : int = -1
var selection : int = -1
@onready var selector : TextureRect = $"Enemy/0/Selector"
@onready var _enemy_cycle_timer : Timer = $EnemyTargetTimer

func init(players : Array[PlayerUnit], enemies : Array[EnemyUnit]) -> void:
	for i : int in 4:
		if players.size() > i:
			_player_units[i] = players[i]
			_actor_timers[i] = 5.0 * players[i].speed + randf_range(30.0, 130.0)
			_player_combat_huds[i].init(players[i].dname, players[i].health, players[i].sharpness, players[i].reagent, players[i].status, players[i].texture)
		else:
			_player_combat_huds[i].hide()
	for i : int in 4:
		if enemies.size() > i:
			_enemy_units[i] = enemies[i]
			_actor_timers[i + 4] = 5.0 * enemies[i].speed + randf_range(35.0, 160.0)
			_enemy_combat_huds[i].init(enemies[i].dname, enemies[i].texture)
		else:
			_enemy_combat_huds[i].hide()
	MusicStreamPlayer.play_music(MusicStreamPlayer.Song.BATTLE)
	run_timers = true

func _player_attack(target : int) -> void:
	await _player_combat_huds[_acting].wiggle_texture(1, 15)
	_enemy_units[target].health -= _enemy_units[target].calculate_damage_taken(_player_units[_acting])
	_player_units[_acting].sharpness -= randi_range(1, 5)
	_player_combat_huds[_acting].update_sharpness(_player_units[_acting].sharpness)
	_player_combat_huds[_acting].wiggle_sharpness(-1, 5)
	if _enemy_units[target].health <= 0:
		await _enemy_combat_huds[target].wiggle(5, 10)
		_enemy_units[target] = null
		_enemy_combat_huds[target].dissolve(1.667)
		if _enemy_units.filter(func(element : EnemyUnit) -> bool: return not element == null).size() == 0:
			state = 1
	else:
		await _enemy_combat_huds[target].wiggle(3, 5)
	_actor_timers[_acting] = 150.0

func _process_player_selection(idx : int) -> void:
	if idx <= 1:
		if idx == 1 and _player_units[_acting].reagent == 0:
			await RenderingServer.frame_pre_draw
			await RenderingServer.frame_pre_draw
			_menu.fail_selection()
			return
		if _enemy_units.filter(func(element : EnemyUnit) -> bool: return not element == null).size() > 1:
			selection = _enemy_units.find_custom(func(element : EnemyUnit) -> bool: return not element == null)
			selector.reparent(_enemy_combat_huds[selection], false)
			selector.show()
		else:
			_menu.hide()
			if idx == 0:
				await _player_attack(_enemy_units.find_custom(func(element : EnemyUnit) -> bool: return not element == null))
			else:
				print("CAST")
				_actor_timers[_acting] = 350.0
			_player_combat_huds[_acting].atb_bar.max_value = _actor_timers[_acting]
			_acting = -1
			run_timers = true
	elif idx == 2:
		if _player_units[_acting].sharpness == 150:
			await RenderingServer.frame_pre_draw
			await RenderingServer.frame_pre_draw
			_menu.fail_selection()
			return
		_menu.hide()
		_player_units[_acting].sharpness = _player_units[_acting].sharpness * 1.1 + 10 
		_player_combat_huds[_acting].update_sharpness(_player_units[_acting].sharpness)
		_player_combat_huds[_acting].wiggle_sharpness(1, 5)
		_actor_timers[_acting] = 100.0
		_player_combat_huds[_acting].atb_bar.max_value = _actor_timers[_acting]
		_acting = -1
		run_timers = true
	else:
		print("ITEMS")
		#region TEMP
		await RenderingServer.frame_pre_draw
		await RenderingServer.frame_pre_draw
		_menu.fail_selection()
		return
		#endregion
		@warning_ignore("unreachable_code") _menu.hide()
		_actor_timers[_acting] = 50.0
		_player_combat_huds[_acting].atb_bar.max_value = _actor_timers[_acting]
		_acting = -1
		run_timers = true

func _ready() -> void:
	_menu.selection.connect(_process_player_selection)
	
	var p : PlayerUnit = PlayerUnit.new()
	p.dname = "MY NAME"
	p.max_health = 15
	p.health = 15
	p.sharpness = 100
	p.strength = 10
	p.texture = preload("res://Textures/HunterPortrait.png")
	var e : Array[EnemyUnit]
	for i : int in 2:
		var ee : EnemyUnit = EnemyUnit.new()
		ee.health = 5
		ee.dname = "ENEMY NAME"
		ee.texture = preload("res://icon.svg")
		ee.strength = 10
		e.append(ee)
	init([p], e)

func _physics_process(delta: float) -> void:
	if not state == 0:
		return
	if run_timers:
		for i : int in 8:
			_actor_timers[i] = maxi(_actor_timers[i] - delta * (
				(_player_units[i].speed + 1.0 if _player_units[i] != null else 0.0)
				if i <= 3 else
				(_enemy_units[i & 3].speed + 1.0 if _enemy_units[i & 3] != null else 0.0)
			),
			0.0)
			if (_player_units[i] != null and _player_units[i].health > 0 if i <= 3 else _enemy_units[i & 3] != null and _enemy_units[i & 3].health > 0) and _actor_timers[i] <= 0.0 and _acting < 0:
				_acting = i
		if _acting >= 0:
			run_timers = false
			if _acting >= 4: # ENEMY ACTION
				await _enemy_combat_huds[_acting & 3].wiggle(1, 15)
				var target : int = randi_range(0, 3) % _player_units.filter(func(element : PlayerUnit) -> bool: return not element == null).size()
				_player_units[target].health -= _player_units[target].calculate_damage_taken(_enemy_units[_acting & 3])
				_player_combat_huds[target].update_health(_player_units[target].health)
				_player_combat_huds[target].wiggle_health(-1, 5)
				if _player_units[target].health <= 0:
					await _player_combat_huds[target].wiggle_texture(5, 10)
					_player_combat_huds[target].trigger_qte()
					_player_combat_huds[target].desaturate(0.5)
					if _player_units.filter(func(element : PlayerUnit) -> bool: return not element == null and element.health > 0).size() == 0:
						state = -1
				else:
					await _player_combat_huds[target].wiggle_texture(3, 5)
				_actor_timers[_acting] = 165.0
				_acting = -1
				run_timers = true
			else:
				_menu.reparent(_player_combat_huds[_acting], false)
				_menu.enable()
	for i : int in 4:
		if _acting < 0 or _acting >= 4:
			if _player_units[i]:
				var timer_qte_int : int = (_timer_qte & (7 << (i * 3))) >> (i * 3)
				if timer_qte_int & 4:
					var chance : float = randf()
					if chance > 0.98:
						var new_qte : int = randi_range(0, 3)
						_timer_qte = (_timer_qte & (~(7 << (i * 3)))) | (new_qte << (i * 3))
						_player_combat_huds[i].set_qte(new_qte)
				else:
					var action : String = "qte_%d" % timer_qte_int
					if InputMap.has_action(action) and Input.is_action_just_pressed(action):
						_player_combat_huds[i].trigger_qte()
						_timer_qte |= 4 << (i * 3)
						_actor_timers[i] = maxi(_actor_timers[i] - 10.0 * (_player_units[i].speed + 1.0), 0.0)
		_player_combat_huds[i].atb_bar.value = _actor_timers[i]
	if selection >= 0:
		if Input.is_action_just_pressed("menu_cancel"):
			selection = -1
			selector.hide()
			_menu.enable(false) # no sfx
			return
		var new_selection : int = -1
		if Input.is_action_just_pressed("menu_left") or (Input.is_action_pressed("menu_left") and _enemy_cycle_timer.time_left == 0):
			_enemy_cycle_timer.start()
			new_selection = _enemy_units.rfind_custom(func(element : EnemyUnit) -> bool: return not element == null, (selection + 3) % 4)
			if new_selection == -1:
				new_selection = _enemy_units.find_custom(func(element : EnemyUnit) -> bool: return not element == null, (selection + 1) % 4)
		if Input.is_action_just_pressed("menu_right") or (Input.is_action_pressed("menu_right") and _enemy_cycle_timer.time_left == 0):
			_enemy_cycle_timer.start()
			new_selection = _enemy_units.find_custom(func(element : EnemyUnit) -> bool: return not element == null, (selection + 1) % 4)
			if new_selection == -1:
				new_selection = _enemy_units.rfind_custom(func(element : EnemyUnit) -> bool: return not element == null, (selection + 3) % 4)
		if new_selection >= 0:
			selection = new_selection
			selector.reparent(_enemy_combat_huds[selection], false)
		if Input.is_action_just_pressed("menu_select"):
			var temp : int = selection
			selection = -1
			selector.hide()
			_menu.hide()
			await _player_attack(temp)
			_player_combat_huds[_acting].atb_bar.max_value = _actor_timers[_acting]
			_acting = -1
			run_timers = true
