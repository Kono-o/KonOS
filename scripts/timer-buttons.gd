extends Node2D

@onready var start_label = get_node("/root/App/UI/timer/buttons/start-label")
@onready var pause_label = get_node("/root/App/UI/timer/buttons/pause-label")
@onready var reset_label = get_node("/root/App/UI/timer/buttons/reset-label")

var startLS
var pauseLS
var resetLS

var started = false
var paused = false
var reset = false

var defaultCol = Color("FFFFFF")
var pressedCol = Color("343B55")

func _ready():
	startLS = start_label.label_settings
	pauseLS = pause_label.label_settings
	resetLS = reset_label.label_settings
func _process(delta):
	if started:
		startLS.font_color = pressedCol
	if !started:
		startLS.font_color = defaultCol
		
	if paused:
		pauseLS.font_color = pressedCol
	if !paused:
		pauseLS.font_color = defaultCol
		
	if reset:
		resetLS.font_color = pressedCol
	if !reset:
		resetLS.font_color = defaultCol

func startDown():
	started = true
func pauseDown():
	paused = true
func resetDown():
	reset = true

func startUp():
	started = false
func pauseUp():
	paused = false
func resetUp():
	reset = false
