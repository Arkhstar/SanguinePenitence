class_name ATBTimerQTE
extends ATBTimer

signal hit_qte
signal update_qte

var qte_input : int = -1 :
	set(v):
		qte_input = v
		update_qte.emit(qte_input)
var recency : float = 0.0
var pulses : int = 0
var epsilon : float = 0.1
var qte_step : float = 2.0

static var momentum : float = 0.0 :
	set(v):
		momentum = clampf(v, 0.0, 1000.0)

func reset(s : float = qte_step, m : float = maximum) -> void:
	super(step, m)
	qte_input = -1
	qte_step = s
	pulses = 0
	recency = 0.0

func on_pulse() -> void:
	if allow_update:
		value = move_toward(value, maximum, step)
		recency = 0.0
		if value == maximum:
			timeout.emit()
			qte_input = -1
			pulses = 0
			return
		if qte_input >= 0 and pulses >= 8:
			qte_input = -1
			pulses = 0
			momentum *= 0.75
			return
		elif qte_input < 0 and pulses >= 4:
			qte_input = randi_range(0, 9)
			pulses = 0
			return
		pulses += 1

func _physics_process(delta: float) -> void:
	if qte_input >= 0 and Input.is_action_just_pressed("qte_%d" % qte_input) and not BattleTimer.i.paused:
		qte_input = -1
		pulses = 0
		if recency < epsilon:
			value = move_toward(value, maximum, qte_step)
			hit_qte.emit(true)
			momentum += qte_step
		else:
			value = move_toward(value, maximum, qte_step / 2.0)
			hit_qte.emit(false)
			momentum += qte_step / 2.0
	recency += delta
