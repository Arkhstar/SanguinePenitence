class_name BoardScrollingCamera
extends Camera2D

@export var player : PlayerController

func _scroll(horizontal : bool) -> void:
	get_tree().paused = true
	var t : Tween = create_tween()
	if horizontal:
		t.tween_property(self, "position", position + Vector2(signf(player.position.x - position.x) * 256., 0.), 1.5)
	else:
		t.tween_property(self, "position", position + Vector2(0., signf(player.position.y - position.y) * 240.), 1.5)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	get_tree().paused = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if absf(player.position.x - position.x) > 128:
		_scroll(true)
	if absf(player.position.y - position.y) > 120:
		_scroll(false)
