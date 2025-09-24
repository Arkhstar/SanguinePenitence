class_name Points
extends Label

static var i : Points

var hopper : int = 0
var amount : int = 0 :
	set(value):
		amount = clampi(value, 0, 99999)
		text = "$%03d.%02d" % [ amount / 100, amount % 100 ]

func _physics_process(_delta: float) -> void:
	if hopper > 0:
		amount += 1
		hopper -= 1
		# speed up for large quantities
		if hopper > 10:
			amount += 8
			hopper -= 8
		if hopper > 100:
			amount += 64
			hopper -= 64

func _ready() -> void:
	i = self

func add_points(quantity : int) -> void:
	hopper += quantity
