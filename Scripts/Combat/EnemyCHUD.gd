class_name EnemyCHUD
extends NinePatchRect

@onready var _name_label : Label = $Name
@onready var _texture : TextureRect = $TextureRect
var _mat : ShaderMaterial

func init(n : String, t : Texture2D) -> void:
	_name_label.text = n
	_texture.texture = t
	_mat = _texture.get_material()

func wiggle(strength : int, frames : int) -> void:
	var max_frames : int = frames
	while frames > 0:
		_texture.position.x = sin(max_frames - frames) * strength
		frames -= 1
		await RenderingServer.frame_post_draw
	while _texture.position.x != 0:
		_texture.position.x = move_toward(_texture.position.x, 0, 1)
		await RenderingServer.frame_post_draw

func _dissolve(p : float) -> void:
	_mat.set_shader_parameter("sensitivity", p)

func dissolve(time : float) -> void:
	var t : Tween = create_tween()
	t.tween_method(_dissolve, 0.0, 1.0, time)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw
	hide()
