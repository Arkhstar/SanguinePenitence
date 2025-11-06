class_name BattleLoseScreen
extends CanvasLayer

@onready var timer : Timer = $Timer
@onready var back : ColorRect = $ColorRect
@onready var text : Label = $Label

func activate() -> void:
	MusicStreamPlayer.adjust_volume(0.0, 1.0)
	
	var t : Tween = create_tween()
	t.tween_property(back, "modulate", Color.WHITE, 4.0).set_trans(Tween.TransitionType.TRANS_SINE)
	
	t.play()
	timer.start(3.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	var u : Tween = create_tween()
	u.tween_property(text, "modulate", Color.WHITE, 3.0).set_trans(Tween.TransitionType.TRANS_SINE)
	u.play()
	timer.start(5.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	var v : Tween = create_tween()
	v.tween_property(text, "modulate", Color.TRANSPARENT, 2.0).set_trans(Tween.TransitionType.TRANS_SINE)
	v.play()
	timer.start(3.0)
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	
	Main.i.die()
