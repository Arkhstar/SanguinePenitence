class_name SaveData
extends Resource

static var altar_level : int = 0 :
	set(v):
		altar_level = v
		if altar_level > highest_altar_level:
			highest_altar_level = altar_level
static var highest_altar_level : int = 0
static var obols : int = 0
static var coinpurse : int = 1000

static var hunter_name : String = "THE HUNTER"

static var text_speed : float = 0.025

static var obelisks : int = 0
