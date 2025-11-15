class_name OracleMenu
extends NPCMenu

@onready var dialogue : DialogueMenu = $DialogueMenu

func init() -> void:
	await dialogue.speak("THE ORACLE", "MESSAGE", ["ANSWER 1", "ANSWER 2"])
	await dialogue.speak("THE ORACLE", "PREDETERMINED RESPONSE")
	close()

func update(_delta : float) -> void:
	return
