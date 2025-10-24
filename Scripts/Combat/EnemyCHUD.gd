class_name EnemyCHUD
extends NinePatchRect

@onready var _name_label : Label = $Name
@onready var _texture : TextureRect = $TextureRect

func init(n : String, t : Texture2D) -> void:
	_name_label.text = n
	_texture.texture = t

func wiggle(strength : int, frames : int) -> void:
	var max_frames : int = frames
	while frames > 0:
		_texture.position.x = sin(max_frames - frames) * strength
		frames -= 1
		await RenderingServer.frame_post_draw
	while _texture.position.x != 0:
		_texture.position.x = move_toward(_texture.position.x, 0, 1)
		await RenderingServer.frame_post_draw
