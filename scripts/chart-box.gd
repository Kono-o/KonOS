extends Node2D

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")
@onready var chart_label_2 = get_node("/root/App/UI/chart-box/chart-label-2")
@onready var chart_param_label = get_node("/root/App/UI/chart-box/chart-param-label")
@onready var chart_data_label = get_node("/root/App/UI/chart-box/chart-data-label")

const PARAM_NAMES = ["weight","calories","carbs","protien","fats"]

const COL_DEF = "0B0E18"
const COL_WHITE = ["1D212D","3D455F","8492C1","DBE2FF"]
const COL_RED = ["2D0B0D","5F0F16","C33D47","FFC1C3"]
const COL_YELLOW = ["372B00","725C00","E6BB00","FFFFC6"]
const COL_ORANGE = ["300E00","682800","D25700","FECEBE"]
const COL_PINK = ["2D0714","60002B","C22464","FEBBCC"]
const COL_GREEN = ["232D00","4D5F00","9FC100","E9FFB4"]
const COL_BLUE = ["12143B","1F205F","5153C2","C6C7FF"]
const COL_VIOLET = ["1D102D","3E1F5F","8751C2","DCC6FF"]

var colorArray = COL_RED

var chartArray = []

var currentParam = 0
var currentValue = 0

func chartInit():
	chartArray.resize(366)
	chartArray.fill(0)

func colorLerp(l):
	var col1 = Color(colorArray[0])
	var col2 = Color(colorArray[1])
	var col3 = Color(colorArray[2])
	var col4 = Color(colorArray[3])
	if l == 0:
		return "[color=%s]" % [Color(COL_DEF).to_html()]
	if l > 0 and l < 0.5:
		return "[color=%s]" % [col1.to_html()]
	if l >= 0.5 and l < 0.75:
		return "[color=%s]" % [col2.to_html()]
	if l >= 0.75 and l < 0.96:
		return "[color=%s]" % [col3.to_html()]
	if l >= 0.96:
		return "[color=%s]" % [col4.to_html()]

func textSet(n):
	var text = ""
	var array = []
	array.resize(chartArray.size())
	array.fill(0)

	var max = 0
	var min = 0
	for i in chartArray.size():
		if chartArray[i] >= max:
			max = chartArray[i]
		if chartArray[i] <= min:
			min = chartArray[i]
	if max == 0:
		max = 1

	for i in array.size():
		array[i] = (chartArray[i]-min)/(max-min)
	for i in 7:
		for j in 26:
				text = '%s%s.' % [text,colorLerp(array[(j*7)+ i + (n * 182)])]
		text = '%s%s' % [text,"\n"]
	
	return text

func updateLabels():
	chart_label_1.text = textSet(0)
	chart_label_2.text = textSet(1)
	chart_param_label.text = PARAM_NAMES[currentParam]
	chart_data_label.text = "(%s)" % [str(currentValue)]

func _ready():
	chartInit()

func getArray(arr,cP,yD,col):
	chartInit()
	currentParam = cP
	currentValue = arr[yD]
	
	if col == "w" or col == "white":
		colorArray = COL_WHITE
	if col == "r" or col == "red":
		colorArray = COL_RED
	if col == "y" or col == "yellow":
		colorArray = COL_YELLOW
	if col == "o" or col == "orange":
		colorArray = COL_ORANGE
	if col == "p" or col == "pink":
		colorArray = COL_PINK
	if col == "g" or col == "green":
		colorArray = COL_GREEN
	if col == "b" or col == "blue":
		colorArray = COL_BLUE
	if col == "v" or col == "violet":
		colorArray = COL_VIOLET
		
	for i in arr.size():
		chartArray[i] = arr[i]
	updateLabels()

