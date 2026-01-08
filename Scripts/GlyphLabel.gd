class_name GlyphLabel
extends Control

@onready var _glyph : Label = $Raw
@onready var _trans : Label = $Trans
var progress : float = 0.0
var animating : bool = false

const CHARACTER_STEP : float = 0.067
const RAW_MAX_VISIBLE_COUNT : int = 10
const TRANS_DELAY : float = CHARACTER_STEP * (RAW_MAX_VISIBLE_COUNT - 1)

func set_text_literal(glyph_text : String, trans_text : String) -> void:
	_glyph.visible_characters = 0
	_trans.visible_characters = 0
	_glyph.text = glyph_text
	_trans.text = trans_text
	progress = 0.0
	animating = true

func set_text_translation_key(key : String) -> void:
	_glyph.visible_characters = 0
	_trans.visible_characters = 0
	_glyph.text = tr("%s-glyph" % key)
	_trans.text = tr(key)
	progress = 0.0
	animating = true

func clear_text() -> void:
	_glyph.text = ""
	_trans.text = ""
	animating = false

func end_animation() -> void:
	animating = false
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
			_glyph.text[raw_prog - RAW_MAX_VISIBLE_COUNT] = " "
	if progress > TRANS_DELAY:
		while floori((progress - TRANS_DELAY) / CHARACTER_STEP) > _trans.visible_characters:
			_trans.visible_characters += 1
