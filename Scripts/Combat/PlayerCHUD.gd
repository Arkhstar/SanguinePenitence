class_name PlayerCHUD
extends NinePatchRect

@onready var _name_label : Label = $Container/Name
@onready var _health_label : Label = $Container/Health
@onready var _sharpness_label : Label = $Container/Sharpness
@onready var _reagent_label : Label = $Container/Reagent
@onready var _status_label : Label = $Container/Status
@onready var _texture : TextureRect = $TextureRect
@onready var atb_bar : TextureProgressBar = $TextureProgressBar
@onready var _qte : Sprite2D = $TextureProgressBar/QTE
var _mat : ShaderMaterial

func init(n : String, h : int, s : int, r : int, u : int, t : Texture2D) -> void:
	_name_label.text = n
	update_health(h)
	update_sharpness(s)
	update_reagent(r)
	update_status(u)
	_texture.texture = t
	_mat = _texture.get_material()

func update_health(h : int) -> void:
	_health_label.text = "HP: %d" % h

func update_sharpness(s : int) -> void:
	_sharpness_label.text = "ES: %d" % s

func update_reagent(r : int) -> void:
	_reagent_label.text = "RG: %s" % ["NONE"][r]

func update_status(u : int) -> void:
	_status_label.text = "SS: %s" % ["NORMAL"][u]

func _wiggle(obj : Control, strength : int, frames : int) -> void:
	var max_frames : int = frames
	while frames > 0:
		obj.position.x = sin(max_frames - frames) * strength
		frames -= 1
		await RenderingServer.frame_post_draw
	while obj.position.x != 0:
		obj.position.x = move_toward(obj.position.x, 0, 1)
		await RenderingServer.frame_post_draw

func wiggle_texture(strength : int, frames : int) -> void:
	await _wiggle(_texture, strength, frames)

func wiggle_health(strength : int, frames : int) -> void:
	await _wiggle(_health_label, strength, frames)

func wiggle_sharpness(strength : int, frames : int) -> void:
	await _wiggle(_sharpness_label, strength, frames)

func set_qte(x : int) -> void:
	_qte.frame = x & 3
	_qte.show()

func trigger_qte() -> void:
	_qte.hide()

func _desaturate(p : float) -> void:
	_mat.set_shader_parameter("strength", p)

func desaturate(time : float) -> void:
	var t : Tween = create_tween()
	t.tween_method(_desaturate, 0.0, 1.0, time)
	t.play()
	while t.is_running():
		await RenderingServer.frame_post_draw

func set_saturation(p : float) -> void:
	_desaturate(p)
