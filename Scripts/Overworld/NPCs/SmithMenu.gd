class_name SmithMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu
@onready var shop : Shop0Menu = $Shop0Menu

func init() -> void:
	dialogue.set_image(Global.TEXTURE_SMITH_PORTRAIT, SaveData.townsfolk & 4)
	var dialogue_options : PackedStringArray = ["SHOP", "TALK", "EXIT"]
	var option : int = await dialogue.speak(Global.get_smith_name(), "WHAT WILL IT BE TODAY?", dialogue_options)
	while option != 2:
		if option == 0:
			shop.open()
			await shop.exit
			shop.close()
			await dialogue.speak(Global.get_smith_name(), "THANKS FOR YOUR BUSINESS.")
		else:
			if SaveData.altar_level >= 1200 and SaveData.townsfolk & 3 and not (SaveData.townsfolk & 4):
				await dialogue.speak(Global.get_smith_name(), "I SCARCE BELIEVE YOU ARE SOURCE TO OUR BOON OF LIGHT. PERHAPS I HAVE BEEN OVERLY HARSH AGAINST YOU.")
				SaveData.townsfolk |= 4
				dialogue.set_image(Global.TEXTURE_SMITH_PORTRAIT, SaveData.townsfolk & 4)
				await dialogue.speak(Global.get_smith_name(), "I AM KNOWN AS %s, AND IT IS A PLEASURE TO MAKE YOUR ACQUAINTANCE, %s." % [Global.get_smith_name(false), SaveData.hunter_name])
				await dialogue.speak("", "%s WILL NOW GIVE YOU DISCOUNTS ON PURCHASES!" % Global.get_smith_name(false))
			elif SaveData.highest_altar_level >= 1200:
				await dialogue.speak(Global.get_smith_name(), "PRAY FORGIVE MY RUDENESS, %s. HOPE HAS BEEN MADE SCARCE THESE PAST MANY MOONS, AND I HOLD FEAR TO MEET IT ONCE MORE." % SaveData.hunter_name)
				await dialogue.speak(Global.get_smith_name(), "BUT YOU HAVE BROUGHT FORTH THE LIGHT OF PROVIDENCE, AND HELD ITS GAZE UPON US.")
				await dialogue.speak(Global.get_smith_name(), "YOU AND YOUR QUEST WILL BE IN MY THOUGHTS. IT IS THE LEAST I CAN DO.")
				if SaveData.townsfolk & 4:
					await dialogue.speak(Global.get_smith_name(), "DONA EIS REQUIEM, %s." % SaveData.hunter_name)
					await dialogue.speak(SaveData.hunter_name, "DONA EIS REQUIEM.")
			elif SaveData.highest_altar_level >= 350:
				await dialogue.speak(Global.get_smith_name(), "THAT YOU STAND BEFORE ME BETRAYS SOME SKILL OF YOURS, BUT YOU'VE YET TO FACE THE MONSTERS OF THE DARK.")
				await dialogue.speak(Global.get_smith_name(), "IF YOU ARE TO BE THE ONE WHO BRINGS US SALVATION, I WOULD ASK YOU TO EVIDENCE YOURSELF.")
				await dialogue.speak(Global.get_smith_name(), "I WOULD FEEL THE WINDS BLOW UPON MY SKIN ONCE MORE. YOU WILL DO THIS FOR ME, AND I WILL ACCEPT YOU.")
			else:
				await dialogue.speak(Global.get_smith_name(), "%s ASKED I RELIGHT THE FORGE, THAT YOU MIGHT ACQUIRE MAINTAINENCE ON YOUR ARMAMENTS." % Global.get_oracle_name(false))
				await dialogue.speak(Global.get_smith_name(), "I WON'T DECEIVE; YOU SEEM ILL CAPABLE TO BRAVE THIS JOURNEY, AND I DON'T REJOICE IN THROWING MY WORK TO SCRAP.")
				await dialogue.speak(Global.get_smith_name(), "THE WILDS ARE WIDE, AND SPARE NO EXPENSE AGAINST YOU.")
		option = await dialogue.speak(Global.get_smith_name(), "IS THERE AUGHT ELSE I MIGHT AID YOU WITH?", dialogue_options)
	await dialogue.speak(Global.get_smith_name(), "MAY THE EYE WATCH OVER YOU.")
	close()

func update(_delta : float) -> void:
	return
