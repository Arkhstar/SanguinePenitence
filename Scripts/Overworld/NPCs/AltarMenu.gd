class_name AltarMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	if SaveData.altar_level <= 0:
		await dialogue.speak("", "A LARGE STONE OBELISK STANDS BEFORE YOU, STARING WITH ITS DARK, STONE-CUT EYE.")
		await dialogue.speak("", "ITS WHISPERS FLOW THROUGH THE WIND, PERMEATING YOUR MIND.", [ "PRAY" ])
		await dialogue.speak("", "A COLD FEELING FLOWS THROUGH YOUR BODY... THOUGH IT IS STRANGELY COMFORTING.")
		SaveData.altar_level = 1
		MusicStreamPlayer.adjust_volume(1.0, 15.0)
	else:
		var option : int = await dialogue.speak("", "YOU STAND BEFORE THE ALTAR.", [ "PRAY", "HUNT", "EXIT" ])
		if option == 0:
			if SaveData.obols > 0:
				option = await dialogue.speak("", "YOU FEEL IT GAZING DOWN AT YOU.", [ "OFFER OBOLS", "JUST PRAY" ])
				if option == 0:
					option = await dialogue.speak("", "HOW MANY OBOLS DO YOU PLACE BEFORE THE ALTAR?", [ "ALL: %d" % SaveData.obols, "HALF: %d" % ceili(SaveData.obols / 2.0), "NONE" ])
					if option == 0:
						SaveData.altar_level += SaveData.obols
						SaveData.obols = 0
						await dialogue.speak("", "THAT SAME COMFORTING FEELING FLOWS THROUGH YOUR BODY, REVITALIZING YOUR BODY AND MIND.")
					elif option == 1:
						option = ceili(SaveData.obols / 2.0)
						SaveData.altar_level += option
						SaveData.obols -= option
						await dialogue.speak("", "THAT SAME COMFORTING FEELING FLOWS THROUGH YOUR BODY, REVITALIZING YOUR BODY AND MIND.")
			await dialogue.speak(SaveData.hunter_name, "... ... ... ... ...")
			await dialogue.speak(SaveData.hunter_name, "... DONA EIS REQUIEM.")
		elif option == 1:
			await MusicStreamPlayer.adjust_volume(0.0, 0.5)
			Main.i.change_scene("res://Scenes/Overworld/wilds.tscn")
			return
	close()

func update(_delta : float) -> void:
	return
