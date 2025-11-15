class_name SmithMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var shop : Shop0Menu = $Shop0Menu

func _ready() -> void:
	shop.exit.connect(func() -> void:
		shop.close()
		dialogue.show()
		await dialogue.speak("THE SMITH", ["DON'T GET YOURSELF KILLED, NOW.","A FINE CHOICE FOR A FINE HUNTER!"][randi_range(0, 1)])
		close())

func init() -> void:
	if await dialogue.speak("THE SMITH", "HAIL, %s. WHAT WILL IT BE TODAY?" % SaveData.hunter_name, ["SHOP", "EXIT"]) == 0:
		dialogue.hide()
		shop.open()
		return
	close()

func update(_delta : float) -> void:
	return
