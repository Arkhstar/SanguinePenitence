class_name HUD
extends CanvasLayer

@onready var health_label : Label = $HealthBar/Label
@onready var health_bar : TextureProgressBar = $HealthBar
var health_bar_anim : Tween = null

func _hurt_anim() -> void:
	if health_bar_anim:
		health_bar_anim.custom_step(5)
	health_bar_anim = create_tween()
	health_bar_anim.tween_property(health_bar, "position", health_bar.position + Vector2(-4, 2), 0.05).set_trans(Tween.TRANS_BOUNCE)
	health_bar_anim.tween_property(health_bar, "position", health_bar.position, 0.05).set_trans(Tween.TRANS_BACK)
	health_bar_anim.play()

func _process(_delta: float) -> void:
	if PlayerController.instance:
		if int(health_label.text) > PlayerController.instance.durability.y:
			_hurt_anim()
		health_label.text = str(PlayerController.instance.durability.y)
		health_label.add_theme_color_override("font_color", Color("#729f9f") if 100.0 * PlayerController.instance.durability.y / PlayerController.instance.durability_max.y > 20.0 else Color("#bd0052"))
		health_bar.value = move_toward(health_bar.value, health_bar.max_value * PlayerController.instance.durability.y / PlayerController.instance.durability_max.y, 10)
