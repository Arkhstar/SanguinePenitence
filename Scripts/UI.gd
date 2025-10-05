class_name UI
extends CanvasLayer

@onready var _cur : Label = $Currency
@onready var _rep : Label = $Reputation
@onready var _adv : Label = $Adventurers

func update_text(money_bcd : int, rep_bcd : int, a_rank_bcd : int, b_rank_bcd : int, c_rank_bcd : int, d_rank_bcd : int) -> void:
	_cur.text = "CURRENCY %05X" % money_bcd
	_rep.text = "REPUTATION %03X" % rep_bcd
	_adv.text = "ADVENTURERS  A%02X B%02X C%02X D%02X" % [ a_rank_bcd, b_rank_bcd, c_rank_bcd, d_rank_bcd ]
