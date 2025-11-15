class_name SmithMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	if await dialogue.speak("THE SMITH", "HAIL, HUNTER. WHAT WILL IT BE TODAY?", ["SHOP", "EXIT"]) == 0:
		print("SHOP")
	close()

func update(_delta : float) -> void:
	return
