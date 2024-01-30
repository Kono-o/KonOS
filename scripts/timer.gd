extends Node2D

@onready var timer_node = get_node("/root/App/UI/timer/timer-node")
@onready var timer_label = get_node("/root/App/UI/timer/timer-label")

var started = false

func updateLabel(t):
	if t < 10:
		timer_label.text = '<%s:%s:%s%s>' % ["00","00","0",int(t)]
	else:
		timer_label.text = '<%s:%s:%s>' % ["00","00",int(t)]

func _ready():
	timer_label.text = "<00:00:00>"
func _process(_delta):
	if started:
		updateLabel(timer_node.time_left)

func terminal_updateTimer(time):
	timer_node.set_wait_time(time)
	updateLabel(time)
func terminal_startTimer():
	started = true
	timer_node.start() 

func timer_Timeout():
	started = false
