class_name Main
extends Node2D

static var instance : Main

@onready var _ui : UI = $UI

var _data : int = 0
var adventurers : Array[Adventurer] = []

func set_money(value : int) -> void:
	_data &= ~0xFFFFF
	_data |= value & 0xFFFFF

func get_money() -> int:
	return absi(_data) & 0xFFFFF

func set_reputation(value : int) -> void:
	_data = absi(_data) & ~0x7FF0000000000000
	_data |= (value & 0x7FF) << 52
	if value & 0x800:
		_data = -absi(_data)

func get_reputation() -> int:
	return ((absi(_data) & 0x7FF0000000000000) >> 52) + (0x800 if _data < 0 else 0x000)

func set_a_ranks(value : int) -> void:
	_data &= ~0xFF00000000000
	_data |= (value & 0xFF) << 44

func get_a_ranks() -> int:
	return ((absi(_data) & 0xFF00000000000) >> 44)

func set_b_ranks(value : int) -> void:
	_data &= ~0xFF000000000
	_data |= (value & 0xFF) << 36

func get_b_ranks() -> int:
	return ((absi(_data) & 0xFF000000000) >> 36)

func set_c_ranks(value : int) -> void:
	_data &= ~0xFF0000000
	_data |= (value & 0xFF) << 28

func get_c_ranks() -> int:
	return ((absi(_data) & 0xFF0000000) >> 28)

func set_d_ranks(value : int) -> void:
	_data &= ~0xFF00000
	_data |= (value & 0xFF) << 20

func get_d_ranks() -> int:
	return ((absi(_data) & 0xFF00000) >> 20)

func add_adventurer(adventurer : Adventurer) -> bool:
	var rank : int = adventurer.get_rank()
	if rank == 0 and get_d_ranks() < 0x99:
		set_d_ranks(get_d_ranks() + 1)
		adventurers.insert(0, adventurer)
		return true
	elif rank == 1 and get_c_ranks() < 0x99:
		set_c_ranks(get_d_ranks() + 1)
		adventurers.insert(get_d_ranks(), adventurer)
		return true
	elif rank == 2 and get_b_ranks() < 0x99:
		set_b_ranks(get_b_ranks() + 1)
		adventurers.insert(get_d_ranks() + get_c_ranks(), adventurer)
		return true
	elif rank == 3 and get_a_ranks() < 0x99:
		set_a_ranks(get_a_ranks() + 1)
		adventurers.insert(get_d_ranks() + get_c_ranks() + get_b_ranks(), adventurer)
		return true
	return false

func remove_adventurer(adventurer : Adventurer) -> void:
	adventurers.erase(adventurer)

func _ready() -> void:
	if instance:
		queue_free()
	else:
		instance = self

func _process(_delta: float) -> void:
	_ui.update_text(get_money(), get_reputation(), get_a_ranks(), get_b_ranks(), get_c_ranks(), get_d_ranks())
