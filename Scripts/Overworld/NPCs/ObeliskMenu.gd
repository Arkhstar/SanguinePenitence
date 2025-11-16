class_name ObeliskMenu
extends NPCMenu

@onready var npc : ObeliskNPC = get_parent()
@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	if npc.active:
		if await dialogue.speak("", "RETURN TO TOWN?", ["YES", "NO"]) == 0:
			Main.i.change_scene("res://Scenes/Overworld/Map/town.tscn")
			return
	else:
		if await dialogue.speak("", "A FAINT HUM CAN BE HEARD FROM THE STONE OBELISK...", [] if SaveData.obols < 50 else ["PAY 50 OBOLS", "EXIT"]) == 0:
			SaveData.obols -= 50
			SaveData.obelisks |= 1 << npc.id
			npc.activate()
			await dialogue.speak("", "THE TOWER BEGINS TO GLOW A SOFT, BLUE LIGHT.")
	close()

func update(_delta : float) -> void:
	return
