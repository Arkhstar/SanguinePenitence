extends CanvasLayer

@onready var rect : ColorRect = $ColorRect

func _ready() -> void:
	if SaveData.altar_level > 0:
		queue_free()

func _process(delta: float) -> void:
	if SaveData.altar_level > 0:
		rect.modulate.a = lerpf(rect.modulate.a, 0.0, delta / 3.0)
