class_name ButcherMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var sell : SellMenu = $SellMenu

func _ready() -> void:
	sell.exit.connect(func() -> void:
		sell.close()
		await dialogue.speak("THE BUTCHER", "... THANKS FOR DOING BUSINESS ...")
		close())

func init() -> void:
	if SaveData.inventory.monster_parts.count(0) == 5:
		await dialogue.speak("THE BUTCHER", "... YOU HAVE NOTHING TO OFFER ...")
		await dialogue.speak("THE BUTCHER", "... COME BACK WITH SOMETHING ...")
	else:
		if await dialogue.speak("THE BUTCHER", "... WHAT ARE YOU OFFERING? ...", ["SELL", "EXIT"]) == 0:
			sell.open()
			return
	close()

func update(_delta : float) -> void:
	return
