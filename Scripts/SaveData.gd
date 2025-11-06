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

static var inventory : Inventory = Inventory.new()

static var hunter_name : String = "THE HUNTER" :
	set(v):
		hunter_name = v
		if hunter_unit:
			hunter_unit.display_name = hunter_name
static var hunter_unit : PlayerUnit = PlayerUnit.new(hunter_name, 100, 10, 10, 0.01, 1.5, 10, 99)

static var obelisks : int = 0

static func load_defaults() -> void:
	altar_level = 0
	highest_altar_level = 0
	obols = 0
	coinpurse = 1000
	hunter_name = "THE HUNTER"
	hunter_unit = PlayerUnit.new(hunter_name, 100, 10, 10, 0.01, 1.5, 10, 99)
	obelisks = 0
