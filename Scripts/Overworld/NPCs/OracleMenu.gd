class_name OracleMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	dialogue.set_image(Global.TEXTURE_ORACLE_PORTRAIT, SaveData.townsfolk & 1)
	if await dialogue.speak(Global.get_oracle_name(), "HARKEN UNTO ME, MY CHILD: EVENTIDE HATH COME.", ["TALK", "EXIT"]) == 0:
		var dialogue_options : PackedStringArray = ["THE REALM", "THE TOWN", "THE ORACLE", "EXIT"]
		var option : int = await dialogue.speak(Global.get_oracle_name(), "I WILL GRANT YOU AUDIENCE. YOU, NOBLE HUNTER, MAY KNOW ALL THAT YOU REQUIRE.", dialogue_options)
		while option != 3:
			if option == 0: # THE REALM
				if SaveData.highest_altar_level >= 2500:
					await dialogue.speak(Global.get_oracle_name(), "ZEPHYR WINDS WILL BLOW ONCE MORE, YET I SHAN'T CHANCE HOPE THEY BLOW ANON.")
					await dialogue.speak(Global.get_oracle_name(), "YOUR EFFORT HAS BROUGHT GRAND SALVATION TO OUR VILLAGE, BUT OUR HOLY LIGHT SHINES DULL AGAINST THE WICKED PITCH.")
					await dialogue.speak(Global.get_oracle_name(), "I BESEECH THEE: FEED THE WANING FLAME, THAT THROUGH SILVER SACRIFICE WE CHANCE MAY BE GRACED WITH DAWN ONCE MORE.")
					if SaveData.townsfolk & 1:
						await dialogue.speak(Global.get_oracle_name(), "MAY GODS HAVE MERCY ON YOUR SOUL, FAIR %s. DONA EIS REQUIEM." % SaveData.hunter_name)
						await dialogue.speak(SaveData.hunter_name, "DONA EIS REQUIEM.")
				elif SaveData.highest_altar_level >= 1000:
					await dialogue.speak(Global.get_oracle_name(), "SPARSE WORD HAS TRAVELLED THE BLACKENED PLAINS AND FOUND ITS WAY HERE, AND ALL WINDS THAT BLOW CARRY ILL TIDINGS.")
					await dialogue.speak(Global.get_oracle_name(), "YET, DO NOT SUCCUMB TO FEAR AND DARKNESS. YOUR TRIUMPH HAS LINGERED LONG AND TRUE - I HAVE NO DOUBT YOU MIGHT FIND VICTORY ETERNAL, AND SAVE US FROM THIS HELLISH PLAGUE.")
					await dialogue.speak(Global.get_oracle_name(), "AFTER ALL, THERE ARE NONE BUT YOU WHO'VE KEPT THE LIGHT OF PROVIDENCE STATIONED ABOVE OUR HUMBLE VILLAGE.")
				elif SaveData.highest_altar_level >= 500:
					await dialogue.speak(Global.get_oracle_name(), "FEW FARE WELL THESE TIMES, AS MOST FARE NOT AT ALL.")
					await dialogue.speak(Global.get_oracle_name(), "YOU CHAMPION THE CAUSE OF FREEDOM, AND WE STAND TALL BEHIND YOU")
				else:
					await dialogue.speak(Global.get_oracle_name(), "THE TRUMPET HATH SOUNDED, AND THE WATERS RUN BLACK WITH BLOOD. WE STAND ATOP THE PRECIPICE OF LIFE AND SQUARE AGAINST THE EMBRACE OF DEATH.")
					await dialogue.speak(Global.get_oracle_name(), "STALWART WE LIVE, AGAINST THE WAVE OF NIGHT. AND YOU, %s, BRAVE THE LASHING WAVES MORE THAN MOST." % SaveData.hunter_name)
					await dialogue.speak(Global.get_oracle_name(), "THROUGH BLOOD AND COIN WILL SALVATION FIND YOU. OF THIS I SWEAR.")
			elif option == 1: # THE TOWN
				if SaveData.highest_altar_level >= 1200:
					await dialogue.speak(Global.get_oracle_name(), "THE ALCHEMIST HAS SEEN HIMSELF FIT TO GRACE THE SKY WITH HIS PRESENCE ONCE MORE.")
					await dialogue.speak(Global.get_oracle_name(), "I KNOW NOT WHAT PURPOSE HIS ELIXIRS MAY SERVE, BUT IF YOU SEE THEM FIT FOR USE I WILL NOT OPPOSE YOU.")
				elif SaveData.highest_altar_level >= 450:
					await dialogue.speak(Global.get_oracle_name(), "A VAGRANT SORCERER SOUGHT SANCTUM FROM THE EVENTIDE. IN EXCHANGE, SHE OFFERED INSIGHTS INTO HER MAGICKS - A BARGAIN NONE COULD REFUSE.")
					await dialogue.speak(Global.get_oracle_name(), "SPELLCRAFT IS A MIGHTY AND DANGEROUS THING. THAT SHE WOULD OFFER IT SO FREELY BESPEAKS HER DIRE STRAITS.")
				elif SaveData.highest_altar_level >= 50:
					await dialogue.speak(Global.get_oracle_name(), "I HAVE HAD WORD WITH THE SMITH, AND JOINED HER TO OUR CAUSE.")
					await dialogue.speak(Global.get_oracle_name(), "THE SANDS OF TIME WILL DULL YOUR BLADE. I IMPLORE YOU TO ACQUAINT YOURSELVES - HER SERVICES WILL BE OF UPMOST USE TO YOU.")
				else:
					await dialogue.speak(Global.get_oracle_name(), "FEW ARE FIT TO FLEE THEIR WALLS IN SUCH TUMULTUOUS TIMES. THEY HIDE AWAY IN FEAR OF THE DARKNESS LOOMING BEYOND THEIR DOORS.")
					await dialogue.speak(Global.get_oracle_name(), "THEY WILL COME TO REASON. WE NEED ONLY LIGHT THE PATH.")
			elif option == 2: # THE ORACLE
				if SaveData.altar_level >= 1000 and not (SaveData.townsfolk & 1):
					await dialogue.speak(Global.get_oracle_name(), "YOU MUST FORGIVE ME. I HAVE FAILED TO INTRODUCE MYSELF AFTER ALL THIS TIME.")
					SaveData.townsfolk |= 1
					dialogue.set_image(Global.TEXTURE_ORACLE_PORTRAIT, SaveData.townsfolk & 1)
					await dialogue.speak(Global.get_oracle_name(), "MY NAME IS %s. IT IS NICE TO FORMALLY MEET YOU, %s. PRAY FORGIVE MY BELATEDNESS IN INTRODUCTION." % [Global.get_oracle_name(false), SaveData.hunter_name])
				elif SaveData.highest_altar_level >= 750:
					await dialogue.speak(Global.get_oracle_name(), "I'M HONORED YOU WOULD ASK AFTER ME AND MINE, BUT I QUESTION WHAT YOU SEEK.")
					await dialogue.speak(Global.get_oracle_name(), "IF YOU MEAN TO HAVE ME JOIN IN YOUR GRAND QUEST, FORGIVE ME BUT I MUST DECLINE. MY DAYS OF GLORY HAVE LONG COME AND PAST.")
					await dialogue.speak(Global.get_oracle_name(), "YOU ARE THE BLADE, AS I AM THE MOUTH.")
				else:
					await dialogue.speak(Global.get_oracle_name(), "AS DID YOU, I FOLLOWED AN AUSPICIOUS CALLING FROM THIS QUEER ALTAR.")
					await dialogue.speak(Global.get_oracle_name(), "IT'S EMBLEM I FAIL TO RECALL, BUT I KNOW ITS CAUSE TO BE JUST: BY SACRIFICE OF SILVER WILL WE BE GRANTED PURITY, AND SAVED FROM THIS FELL CURSE.")
					await dialogue.speak(Global.get_oracle_name(), "YOU ARE MARKED ITS BLADE, AND I ITS MOUTH.")
			option = await dialogue.speak(Global.get_oracle_name(), "MAY THERE BE AUGHT ELSE YOU SEEK TO INQUIRE AFTER?", dialogue_options)
		await dialogue.speak(Global.get_oracle_name(), "FARE THEE WELL, %s, AND MAY YOU STAY IN SIGHT." % SaveData.hunter_name)
	else:
		if SaveData.townsfolk & 1:
			await dialogue.speak(Global.get_oracle_name(), "KEEP WARY, %s. YOU BRING HOPE TO MANY - YOU CANNOT LOSE NOW." % SaveData.hunter_name)
		else:
			await dialogue.speak(Global.get_oracle_name(), "KEEP WARY, NOBLE HUNTER. IN THESE DARK DAYS, FEW ARE THOSE WHO MEAN YOU NO HARM.")
	close()

func update(_delta : float) -> void:
	return
