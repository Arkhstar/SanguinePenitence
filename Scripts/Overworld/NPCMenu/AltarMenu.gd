class_name AltarMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	if SaveData.altar_level <= 0:
		await dialogue.speak("", "THE PILLAR WHISPERS TO YOU...", [ "PRAY" ])
		await dialogue.speak("", "A COLD FEELING FLOWS THROUGH YOUR BODY... THOUGH IT IS STRANGELY COMFORTING.")
		SaveData.altar_level = 1
		MusicStreamPlayer.adjust_volume(1.0, 15.0)
		close()
	else:
		var option : int = await dialogue.speak("", "YOU STAND BEFORE THE ALTAR", [ "PRAY", "HUNT", "EXIT" ])
		if option == 0:
			var cost : int = 250 * SaveData.altar_level
			if SaveData.obols >= cost:
				option = await dialogue.speak("", "YOU FEEL IT GAZING DOWN AT YOU %s." % ["EXPECTANTLY" if SaveData.altar_level <= 5 else "HUNGRILY"], [ "PAY %d OBOLS" % cost, "REFUSE" ])
				if option == 0:
					SaveData.obols -= cost
					SaveData.altar_level += 1
					await dialogue.speak(SaveData.hunter_name, "... ... ... ... ...")
					await dialogue.speak(SaveData.hunter_name, "... DONA EIS REQUIEM.")
				else:
					await dialogue.speak("", "THE ALTAR'S GAZE BURNS INTO YOU.")
			else:
				await dialogue.speak("", "THE ALTAR'S EYE LOOKS THROUGH YOU, AS THOUGH YOU WERE NOT EVEN THERE.")
				await dialogue.speak("", "IT WILL NOT OFFER YOU COMFORTS AS YOU ARE NOW.")
		elif option == 1:
			print("GO HUNTING")
		close()
