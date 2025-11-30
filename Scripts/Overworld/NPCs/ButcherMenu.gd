class_name ButcherMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var sell : SellMenu = $SellMenu

func init() -> void:
	dialogue.set_image(Global.TEXTURE_BUTCHER_PORTRAIT, SaveData.townsfolk & 2)
	var dialogue_options : PackedStringArray = ["SELL", "TALK", "EXIT"]
	var option : int = await dialogue.speak(Global.get_butcher_name(), "... WHAT ARE YOU OFFERING? ...", dialogue_options)
	while option != 2:
		if option == 0:
			if SaveData.inventory.monster_parts.count(0) == 5:
				await dialogue.speak(Global.get_butcher_name(), "... YOU HAVE NOTHING TO OFFER ...")
				await dialogue.speak(Global.get_butcher_name(), "... COME BACK WITH SOMETHING ...")
			else:
				sell.open()
				await sell.exit
				sell.close()
				await dialogue.speak(Global.get_butcher_name(), "... ASK NO QUESTIONS ... AND NONE WILL BE ASKED OF YOU ...")
		else:
			if SaveData.altar_level >= 600 and not SaveData.townsfolk & 2:
				await dialogue.speak(Global.get_butcher_name(), "... YOU COME HERE OFTEN, ... BEARING FRUITS ... OF LABOR ...")
				SaveData.townsfolk |= 2
				dialogue.set_image(Global.TEXTURE_BUTCHER_PORTRAIT, SaveData.townsfolk & 2)
				await dialogue.speak(Global.get_butcher_name(), "... YOU MAY CALL ME ... %s, ... FRIEND ..." % Global.get_butcher_name(false))
				await dialogue.speak("", "%s WILL NOW BUY FROM YOU AT A HIGHER RATE!" % Global.get_butcher_name(false))
			elif SaveData.highest_altar_level >= 2000:
				await dialogue.speak(Global.get_butcher_name(), "... SILVER IS ... FOREIGN TO THE BODY ...")
				await dialogue.speak(Global.get_butcher_name(), "... YET I PULL IT ... FROM THE FLESH ...")
				await dialogue.speak(Global.get_butcher_name(), "... I KNOW NOT OF ... ITS ORIGIN ... ONLY ITS PURPOSE ...")
				await dialogue.speak(Global.get_butcher_name(), "... ... ...")
			elif SaveData.highest_altar_level >= 350:
				await dialogue.speak(Global.get_butcher_name(), "... THE FOREST IS ... QUIET ... IT IS STILL ...")
				await dialogue.speak(Global.get_butcher_name(), "... IT IS WRONG ... UNNATURAL ...")
				await dialogue.speak(Global.get_butcher_name(), "... WHO WOULD CAST ... SUCH A HORRIBLE CURSE? ...")
			else:
				await dialogue.speak(Global.get_butcher_name(), "... I HAVE NOTHING ... TO SAY TO YOU, ... HUNTER ...")
				await dialogue.speak(Global.get_butcher_name(), "... OUR RELATION IS ... CONTRACTUAL ...")
				await dialogue.speak(Global.get_butcher_name(), "... I AM YET ... TO KNOW YOU ...")
		option = await dialogue.speak(Global.get_butcher_name(), "... AUGHT ELSE? ...", dialogue_options)
	await dialogue.speak(Global.get_butcher_name(), "... STAY SAFE, ... %s ..." % [SaveData.hunter_name if SaveData.townsfolk & 2 else "HUNTER"])
	close()

func update(_delta : float) -> void:
	return
