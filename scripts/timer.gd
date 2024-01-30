extends Node2D

@onready var timer_node = get_node("/root/App/UI/timer/timer-node")
@onready var timer_label = get_node("/root/App/UI/timer/timer-label")
@onready var timer_line_label = get_node("/root/App/UI/timer/timer-line-label")

var timerLine = "----------------------------------------------------"
var globalTime = 0
var started = false
var pauseToggle = false

func updateLabel(t):
	t  = int(abs(t))
	if t > 86400:
		t = 86400
	var secs = t % 60
	var mins = ((t-secs)/60) % 60
	var hrs = ((t-secs)/3600) % 60
	
	var secS = ""
	var minS = ""
	var hrS = ""

	if secs < 10:
		secS = '0%s' %[secs]
	if secs > 9 and secs <= 60:
		secS = str(secs)
	
	if mins < 10:
		minS = '0%s' %[mins]
	if mins > 9 and mins <= 60:
		minS = str(mins)
	
	if hrs < 10:
		hrS = '0%s' %[hrs]
	if hrs > 9 and hrs <= 24:
		hrS = str(hrs)
	
	var normT = 0
	if globalTime !=0:
		normT = 1 - (t * (1.0/globalTime))
	normT = normT * timerLine.length()
	for i in normT:
		timerLine[i] = ">"
	timer_line_label.text = timerLine
	
	timer_label.text = '<%s:%s:%s>' % [hrS,minS,secS]
	return (secs + (mins * 60) + (hrs * 3600))

func _ready():
	timer_label.text = "<00:00:00>"
func _process(_delta):
	if started:
		updateLabel(timer_node.time_left)

func terminal_updateTimer(time):
	timer_node.set_wait_time(updateLabel(time))
	globalTime = updateLabel(time)
func terminal_startTimer():
	if !started:
		started = true
		timer_node.start()
	if pauseToggle:
		timer_node.set_wait_time(timer_node.time_left)
		pauseToggle = false
		timer_node.set_paused(pauseToggle)
func terminal_pauseTimer():
	pauseToggle = !pauseToggle
	timer_node.set_paused(pauseToggle)

func timer_Timeout():
	started = false
	globalTime = 0
	timerLine = "----------------------------------------------------"
	timer_line_label.text = timerLine
