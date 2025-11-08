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

static var hunter_name : String = "NULL" :
	set(v):
		hunter_name = v
		if hunter_unit:
			hunter_unit.display_name = hunter_name
static var hunter_unit : PlayerUnit = null

static var obelisks : int = 0

static func load_defaults() -> void:
	altar_level = 0
	highest_altar_level = 0
	obols = 0
	coinpurse = 1000
	inventory = Inventory.new()
	hunter_name = "THE HUNTER"
	hunter_unit = PlayerUnit.new(hunter_name, 30, 30, 10, 6, 0.01, 1.25, 4.0, 25, 0)
	obelisks = 0

static func has_save_file() -> bool:
	return FileAccess.file_exists(_get_path())

static func make_save_file() -> FileAccess:
	return FileAccess.open(_get_path(), FileAccess.WRITE_READ)

static func load_save_file() -> void:
	if has_save_file():
		var f : FileAccess = FileAccess.open(_get_path(), FileAccess.READ)
		if FileAccess.get_open_error() == OK:
			var contents : String = f.get_as_text()
			var json : JSON = JSON.new()
			if json.parse(contents) == OK:
				var data : Variant = json.data
				if data is Dictionary:
					altar_level = data["clvl"]
					highest_altar_level = data["hlvl"]
					obols = data["obol"]
					coinpurse = data["cprs"]
					inventory = Inventory.from_str(data["invt"])
					hunter_name = data["name"]
					hunter_unit = PlayerUnit.from_str(data["hntr"])
					obelisks = data["blsk"]
					return
		push_error("Something went wrong loading save file")
	load_defaults()

static func write_save_file() -> void:
	var f : FileAccess = make_save_file()
	if FileAccess.get_open_error() == OK:
		f.store_string(to_str())

static func to_str() -> String:
	var dict : Dictionary = {
		"clvl" : altar_level,
		"hlvl" : highest_altar_level,
		"obol" : obols,
		"cprs" : coinpurse,
		"invt" : inventory.to_str(),
		"name" : hunter_name,
		"hntr" : hunter_unit.to_str(),
		"blsk" : obelisks
	}
	return JSON.stringify(dict)

static func _get_path() -> String:
	return OS.get_user_data_dir() + "/save.data"
