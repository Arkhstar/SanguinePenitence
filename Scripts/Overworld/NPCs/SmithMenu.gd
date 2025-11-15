class_name SmithMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	if await dialogue.speak("THE SMITH", "HAIL, %s. WHAT WILL IT BE TODAY?" % SaveData.hunter_name, ["SHOP", "EXIT"]) == 0:
		print("SHOP")
	close()

func update(_delta : float) -> void:
	return
