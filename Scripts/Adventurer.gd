class_name Adventurer
extends Resource

var _title : int = 0
var _stats : int = 0

func _init(title : String, strength : int, intelligence : int, faith : int, will : int, visual : int) -> void:
	set_title(title)
	set_strength(strength)
	set_intelligence(intelligence)
	set_faith(faith)
	set_will(will)
	set_job(visual)
	set_palette(visual >> 3)

func set_title(value : String) -> void:
	_title = value.left(8).to_ascii_buffer().hex_encode().hex_to_int()

func get_title() -> String:
	return ("%X"%_title).hex_decode().get_string_from_ascii()

func set_strength(value : int) -> void:
	_stats &= ~0x7F
	_stats |= value & 0x7F

func get_strength() -> int:
	return _stats & 0x7F

func set_intelligence(value : int) -> void:
	_stats &= ~0x3F80
	_stats |= (value & 0x7F) << 7

func get_intelligence() -> int:
	return (_stats & 0x3F80) >> 7

func set_faith(value : int) -> void:
	_stats &= ~0x1FC000
	_stats |= (value & 0x7F) << 14

func get_faith() -> int:
	return (_stats & 0x1FC000) >> 14

func set_will(value : int) -> void:
	_stats &= ~0xFE00000
	_stats |= (value & 0x7F) << 21

func get_will() -> int:
	return (_stats & 0xFE00000) >> 21

func set_job(value : int) -> void:
	_stats &= ~0x70000000
	_stats |= (value & 0x7) << 28

func get_job() -> int:
	return (_stats & 0x70000000) >> 28

func set_palette(value : int) -> void:
	_stats &= ~0x180000000
	_stats |= (value & 0x3) << 31

func get_palette() -> int:
	return (_stats & 0x180000000) >> 31

func get_rank() -> int:
	var stats_mean : int = (get_strength() + get_intelligence() + get_faith() + get_will()) / 4
	if stats_mean > 0x40:
		return 3
	if stats_mean > 0x10:
		return 2
	if stats_mean > 0x04:
		return 1
	return 0
