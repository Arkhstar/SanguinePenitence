class_name NPCMenu
extends CanvasLayer

var ignore_input : bool = true

func init() -> void:
	return

func update(_delta : float) -> void:
	if Input.is_action_just_pressed("menu_cancel"):
		close()

func open() -> void:
	OverworldPlayer.i.ignore_input = true
	init()
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	show()
	ignore_input = false

func close() -> void:
	ignore_input = true
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	SaveData.write_save_file()
	OverworldPlayer.i.ignore_input = false
	hide()

func _physics_process(delta: float) -> void:
	if ignore_input:
		return
	update(delta)
