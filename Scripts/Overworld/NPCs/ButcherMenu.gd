class_name ButcherMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var sell : SellMenu = $SellMenu

func _ready() -> void:
	sell.exit.connect(func() -> void:
		sell.close()
		dialogue.show()
		await dialogue.speak("THE BUTCHER", ["... ASK NO QUESTIONS AND NONE WILL BE ASKED OF YOU ...","... THANKS FOR DOING BUSINESS ..."][randi_range(0,1)])
		close())

func init() -> void:
	if SaveData.inventory.monster_parts.count(0) == 5:
		await dialogue.speak("THE BUTCHER", "... YOU HAVE NOTHING TO OFFER ...")
		await dialogue.speak("THE BUTCHER", "... COME BACK WITH SOMETHING ...")
	else:
		if await dialogue.speak("THE BUTCHER", "... WHAT ARE YOU OFFERING? ...", ["SELL", "EXIT"]) == 0:
			dialogue.hide()
			sell.open()
			return
	close()

func update(_delta : float) -> void:
	return
