class_name BattleLoseScreen
extends CanvasLayer

@onready var timer : Timer = $Timer
@onready var back : ColorRect = $ColorRect
@onready var text : TextureRect = $TextureRect
@onready var game_over : AudioStreamPlayer = $GameOverJingle

func activate() -> void:
	await get_tree().create_timer(1.0).timeout
	MusicStreamPlayer.adjust_volume(0.0, 3.0)
	
	var t1 : Tween = create_tween()
	t1.tween_property(game_over, "volume_linear", 1.0, 4.0)
	
	game_over.play()
	t1.play()
	
	var t2 : Tween = create_tween()
	t2.tween_property(back, "modulate", Color.WHITE, 4.0).set_trans(Tween.TransitionType.TRANS_SINE)
	
	t2.play()
	timer.start(4.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	var t3 : Tween = create_tween()
	t3.tween_property(text, "modulate", Color.WHITE, 6.0).set_trans(Tween.TransitionType.TRANS_SINE)
	t3.play()
	timer.start(20.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	var t4 : Tween = create_tween()
	t4.tween_property(text, "modulate", Color.TRANSPARENT, 4.0).set_trans(Tween.TransitionType.TRANS_SINE)
	t4.play()
	timer.start(4.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	var t5 : Tween = create_tween()
	t5.tween_property(game_over, "volume_linear", 0.0, 4.0)
	t5.play()
	while t5.is_running():
		await RenderingServer.frame_post_draw
	
	Main.i.die()
