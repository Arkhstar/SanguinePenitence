class_name SmithMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var shop : Shop0Menu = $Shop0Menu

var display_name : String = "THE SMITH"

func _ready() -> void:
	shop.exit.connect(func() -> void:
		shop.close()
		await dialogue.speak(display_name, ["DON'T GET YOURSELF KILLED, NOW.","A FINE CHOICE FOR A FINE HUNTER!"][randi_range(0, 1)])
		close())

func init() -> void:
	dialogue.set_image(preload("res://Textures/Characters/Smith/Portrait.png"), SaveData.townsfolk & 4)
	if SaveData.townsfolk & 4:
		display_name = "GAVEIRAH, THE SMITH"
	if await dialogue.speak(display_name, "HAIL, %s. WHAT WILL IT BE TODAY?" % SaveData.hunter_name, ["SHOP", "EXIT"]) == 0:
		shop.open()
		return
	close()

func update(_delta : float) -> void:
	return
