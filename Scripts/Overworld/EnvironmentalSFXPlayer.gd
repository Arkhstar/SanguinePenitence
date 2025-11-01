class_name EnvironmentalSFXPlayer
extends AudioStreamPlayer

@export var sfx_variants : Array[AudioStreamOggVorbis] = []
@export var delay_range : Vector2 = Vector2(0.5, 1.5)
@export var pitch_range : Vector2 = Vector2(0.95, 1.05)
@onready var timer : float = randf_range(delay_range.x, delay_range.y)

func _process(delta : float) -> void:
	if not playing:
		timer -= delta
		
		if timer <= 0:
			timer = randf_range(delay_range.x, delay_range.y)
			stream = sfx_variants.pick_random()
			pitch_scale = randf_range(pitch_range.x, pitch_range.y)
			play()
