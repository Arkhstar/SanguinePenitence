class_name Global
extends Resource

const TEXTURE_ORACLE_PORTRAIT : Texture2D = preload("res://Textures/Characters/Smith/Portrait.png")
const TEXTURE_BUTCHER_PORTRAIT : Texture2D = preload("res://Textures/Characters/Smith/Portrait.png")
const TEXTURE_SMITH_PORTRAIT : Texture2D = preload("res://Textures/Characters/Smith/Portrait.png")
const TEXTURE_SORCERER_PORTRAIT : Texture2D = preload("res://Textures/Characters/Smith/Portrait.png")
const TEXTURE_ALCHEMIST_PORTRAIT : Texture2D = preload("res://Textures/Characters/Smith/Portrait.png")

const TEXTURE_OPTION_CYCLE_ON : Texture2D = preload("res://Textures/Menu/Selector/CycleLight.png")
const TEXTURE_OPTION_CYCLE_OFF : Texture2D = preload("res://Textures/Menu/Selector/CycleDark.png")

const COLOR_BLUE_0 : Color = Color("222b47")
const COLOR_BLUE_1 : Color = Color("354461")
const COLOR_BLUE_2 : Color = Color("4b6c81")
const COLOR_BLUE_3 : Color = Color("729f9f")
const COLOR_BLUE_ARRAY : Array[Color] = [ COLOR_BLUE_0, COLOR_BLUE_1, COLOR_BLUE_2, COLOR_BLUE_3 ]

const COLOR_GRAY_0 : Color = Color("8a9094")
const COLOR_GRAY_1 : Color = Color("495058")
const COLOR_GRAY_2 : Color = Color("394047")
const COLOR_GRAY_3 : Color = Color("1b2025")
const COLOR_GRAY_4 : Color = Color("0f1216")

static func get_oracle_name(title : bool = true) -> String:
	if not SaveData.townsfolk & 1:
		return "THE ORACLE"
	if title:
		return "YEROD, THE ORACLE"
	return "YEROD"

static func get_butcher_name(title : bool = true) -> String:
	if not SaveData.townsfolk & 2:
		return "THE BUTCHER"
	if title:
		return "HESSYN, THE BUTCHER"
	return "HESSYN"

static func get_smith_name(title : bool = true) -> String:
	if not SaveData.townsfolk & 4:
		return "THE SMITH"
	if title:
		return "GAVEIRAH, THE SMITH"
	return "GAVEIRAH"

static func get_sorcerer_name(title : bool = true) -> String:
	if not SaveData.townsfolk & 8:
		return "THE SORCERER"
	if title:
		return "NEHZAIA, THE SORCERER"
	return "NEHZAIA"

static func get_alchemist_name(title : bool = true) -> String:
	if not SaveData.townsfolk & 16:
		return "THE ALCHEMIST"
	if title:
		return "HOFRYN, THE ALCHEMIST"
	return "HOFRYN"
