class_name WebSettingsOption
extends SettingsOption

func _physics_process(delta: float) -> void:
	if OS.has_feature("web"):
		l.hide()
		r.hide()
		option.text = "FIXED"
		option.add_theme_color_override("font_color", Global.COLOR_GRAY_4)
		add_theme_color_override("font_color", Global.COLOR_GRAY_4)
		s.call(-1)
	else:
		super(delta)
