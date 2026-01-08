class_name GlyphLabel
extends Control

signal animation_state_changed

@onready var _glyph : Label = $Raw
@onready var _trans : Label = $Trans
var progress : float = 0.0
var animating : bool = false :
	set(value):
		animating = value
		animation_state_changed.emit(animating)

const CHARACTER_STEP : float = 0.05
const RAW_MAX_VISIBLE_COUNT : int = 16
const TRANS_DELAY : float = CHARACTER_STEP * (RAW_MAX_VISIBLE_COUNT)

func set_text(key : String) -> void:
	_glyph.visible_characters = 0
	_trans.visible_characters = 0
	_glyph.text = tr("%s-g" % key)
	_trans.text = tr(key)
	progress = 0.0
	animating = true

func clear_text() -> void:
	_glyph.text = ""
	_trans.text = ""
	progress = 0.0
	animating = false

func end_animation() -> void:
	animating = false
	progress = 1.0
	_glyph.visible_characters = 0
	_trans.visible_characters = -1

func _physics_process(delta: float) -> void:
	if not animating:
		return
	progress += delta
	var raw_prog : int = floori(progress / CHARACTER_STEP)
	while raw_prog > _glyph.visible_characters:
		_glyph.visible_characters += 1
		if raw_prog >= RAW_MAX_VISIBLE_COUNT and raw_prog < _glyph.text.length() + RAW_MAX_VISIBLE_COUNT:
			_glyph.text[raw_prog - RAW_MAX_VISIBLE_COUNT] = 'a' if _glyph.text[raw_prog - RAW_MAX_VISIBLE_COUNT] != ' ' else ' '
	if progress > TRANS_DELAY:
		while floori((progress - TRANS_DELAY) / CHARACTER_STEP) > _trans.visible_characters:
			_trans.visible_characters += 1
	if _trans.visible_characters >= _trans.text.length() and _glyph.visible_characters >= _glyph.text.length() + RAW_MAX_VISIBLE_COUNT:
		end_animation()
