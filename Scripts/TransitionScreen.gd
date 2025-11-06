extends CanvasLayer

@onready var panel : ColorRect = $ColorRect

func fade_in(time : float = 1.0) -> void:
	var t : Tween = create_tween()
	t.tween_property(panel, "modulate", Color.WHITE, time)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw

func fade_out(time : float = 1.0) -> void:
	var t : Tween = create_tween()
	t.tween_property(panel, "modulate", Color.TRANSPARENT, time)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
