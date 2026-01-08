class_name TextPanel
extends Control

@onready var _label : GlyphLabel = $Panel/GlyphLabel

@onready var _title_panel : NinePatchRect = $Speaker
@onready var _speaker : GlyphLabel = $Speaker/GlyphLabel

@onready var _throbber : AnimatedSprite2D = $Panel/Throbber

func set_text(key : String) -> void:
	_label.set_text(key)

func clear_text() -> void:
	_label.clear_text()

func end_animation() -> void:
	_label.end_animation()

func set_title(key : String) -> void:
	_speaker.set_text(key)

func clear_title() -> void:
	_speaker.clear_text()

func end_title_animation() -> void:
	_speaker.end_animation()

func show_title() -> void:
	_title_panel.show()

func hide_title() -> void:
	_title_panel.hide()

func _ready() -> void:
	_label.animation_state_changed.connect(func(is_animating : bool) -> void:
		if is_animating:
			_throbber.hide()
			_throbber.stop()
		else:
			_throbber.play("default")
			_throbber.show()
		return)
	_label.set_text("TEST MESSAGE: LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM LOREM IPSUM.!?")
	_speaker.set_text("SPEAKER NAME GOES HERE")
