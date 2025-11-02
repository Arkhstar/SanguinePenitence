class_name OracleMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	await dialogue.speak("FUNKY LITTLE GUY", "WOW. THAT WAS LOWKEY SO FIRE OF YOU TO TALK TO ME LIKE THAT, BUT I DON'T HAVE ANY DIALOGUE YET... SO... WASSUP I GUESS?", ["NOT MUCH", "NOTHING"])
	await dialogue.speak("FUNKY LITTLE GUY", "EPIC.")
	close()

func update(_delta : float) -> void:
	return
