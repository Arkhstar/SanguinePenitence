class_name BattleSelector
extends TextureRect

signal selection

var displays : Array[Control] = []

var ignore_input : bool = true
var index : int = 0
var player : bool = false

func set_targeting_players() -> void:
	index = -1
	player = true
	flip_v = true
	inc_index()
	update_position()
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	ignore_input = false

func set_targeting_enemies() -> void:
	index = -1
	player = false
	flip_v = false
	inc_index()
	update_position()
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	ignore_input = false

func dec_index() -> void:
	for i : int in 4:
		var next_idx : int = (index + i * 3 + 3) % 4
		if not player:
			next_idx += 4
		if displays[next_idx].visible and displays[next_idx].unit and displays[next_idx].unit.health > 0:
			index = next_idx
			return

func inc_index() -> void:
	for i : int in 4:
		var next_idx : int = (index + i + 1) % 4
		if not player:
			next_idx += 4
		if displays[next_idx].visible and displays[next_idx].unit and displays[next_idx].unit.health > 0:
			index = next_idx
			return

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
		dec_index()
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
		inc_index()
	
	update_position()
	
	if Input.is_action_just_pressed("menu_select"):
		selection.emit(index)
		return
	if Input.is_action_just_pressed("menu_cancel"):
		selection.emit(-1)

func update_position() -> void:
	if player:
		global_position = displays[index].global_position + Vector2(52.0, -18.0)
	else:
		global_position = displays[index].global_position + Vector2(52.0, 37.0)

func pulse_anim() -> void:
	flip_h = not flip_h
