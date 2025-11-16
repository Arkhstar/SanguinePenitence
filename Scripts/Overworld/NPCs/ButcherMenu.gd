class_name ButcherMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var sell : SellMenu = $SellMenu

var display_name : String = "THE BUTCHER"

func _ready() -> void:
	sell.exit.connect(func() -> void:
		sell.close()
		dialogue.show()
		await dialogue.speak(display_name, ["... ASK NO QUESTIONS AND NONE WILL BE ASKED OF YOU ...","... THANKS FOR DOING BUSINESS ..."][randi_range(0,1)])
		close())

func init() -> void:
	if SaveData.townsfolk & 2:
		display_name = "HESSYN, THE BUTCHER"
	if SaveData.inventory.monster_parts.count(0) == 5:
		await dialogue.speak(display_name, "... YOU HAVE NOTHING TO OFFER ...")
		await dialogue.speak(display_name, "... COME BACK WITH SOMETHING ...")
	else:
		if await dialogue.speak(display_name, "... WHAT ARE YOU OFFERING? ...", ["SELL", "EXIT"]) == 0:
			dialogue.hide()
			sell.open()
			return
	close()

func update(_delta : float) -> void:
	return
