class_name TargetIndicator
extends TextureRect

@onready var animator : AnimationPlayer = $AnimationPlayer
var queue : PackedByteArray = []

func enqueue(i : int) -> void:
	queue.append(i)
	_play_enqueued()

func _play_enqueued() -> void:
	if queue.size() > 0 and not animator.is_playing():
		var v : int = queue.decode_s8(0)
		if v == 0:
			animator.play("out")
		elif v == 1:
			animator.play("in")
		elif v == 2:
			animator.play_backwards("in")
		queue.remove_at(0)

func _on_anim_finished(_anim_name: StringName) -> void:
	_play_enqueued()
