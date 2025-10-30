class_name BattleSelector
extends TextureRect

signal selection

var displays : Array[Control] = []

var ignore_input : bool = true
var index : int = 0
var player : bool = false

func set_targeting_players() -> void:
	index = -1
	inc_index()
	player = true
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	ignore_input = false

func set_targeting_enemies() -> void:
	index = -1
	inc_index()
	player = false
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	ignore_input = false

func dec_index() -> void:
	if player:
		for i : int in 4:
			if not displays[(index + i + 3) % 4]._health.text.contains("HP: %3d" % 0):
				index = (index + i + 3) % 4
				return
	else:
		for i : int in 4:
			if displays[(index + i * 3 + 3) % 4 + 4].visible:
				index = (index + i * 3 + 3) % 4
				return

func inc_index() -> void:
	if player:
		for i : int in 4:
			if not displays[(index + i + 1) % 4]._health.text.contains("HP: %3d" % 0):
				index = (index + i + 1) % 4
				return
	else:
		for i : int in 4:
			if displays[(index + i + 1) % 4 + 4].visible:
				index = (index + i + 1) % 4
				return

func _physics_process(_delta: float) -> void:
	if ignore_input:
		return
	
	if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
		dec_index()
	if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
		inc_index()
	if player:
		global_position = displays[index].global_position + Vector2(52.0, -18.0)
	else:
		global_position = displays[index + 4].global_position + Vector2(52.0, 37.0)
	if Input.is_action_just_pressed("menu_select"):
		selection.emit(index if player else index + 4)
		return
	if Input.is_action_just_pressed("menu_cancel"):
		selection.emit(-1)

func pulse_anim() -> void:
	flip_h = not flip_h
