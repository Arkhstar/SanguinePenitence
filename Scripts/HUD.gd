class_name HUD
extends CanvasLayer

@onready var shield_bar : TextureProgressBar = $ShieldBar
@onready var shield_label : Label = $ShieldBar/Label

@onready var sword_bar : TextureProgressBar = $SwordBar
@onready var sword_label : Label = $SwordBar/Label

var hurt_anim : Tween = null

func _hurt_anim() -> void:
	if hurt_anim:
		hurt_anim.custom_step(5)
	hurt_anim = create_tween()
	hurt_anim.tween_property(shield_bar, "position", Vector2(35.0, 11.0), 0.05).set_trans(Tween.TRANS_BOUNCE)
	hurt_anim.tween_property(shield_bar, "position", Vector2(36.0, 12.0), 0.05).set_trans(Tween.TRANS_BACK)
	hurt_anim.play()

func _process(_delta: float) -> void:
	if PlayerController.instance:
		var stats : Vector2i = PlayerController.instance.durability
		if int(shield_label.text) > stats.y:
			_hurt_anim()
		sword_label.text = str(stats.x)
		shield_label.text = str(stats.y)
		sword_bar.value = move_toward(sword_bar.value, sword_bar.max_value * stats.x / PlayerController.instance.durability_max.x, 10)
		shield_bar.value = move_toward(shield_bar.value, shield_bar.max_value * stats.y / PlayerController.instance.durability_max.y, 10)
