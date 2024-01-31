extends Node2D

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")
@onready var chart_label_2 = get_node("/root/App/UI/chart-box/chart-label-2")
@onready var chart_param_label = get_node("/root/App/UI/chart-box/chart-param-label")
@onready var chart_data_label = get_node("/root/App/UI/chart-box/chart-data-label")

const PARAM_NAMES = ["weight","calories","carbs","protien","fats"]

const COLOR_ARRAY = ["#101010","#080808","#ffffff"]
#const COLOR_ARRAY = ["#101010","#3a32a8","#cfccff"]

var chartArray1 = []
var chartArray2 = []

var currentParam = 0
var currentValue = 0

func chartInit():
	chartArray1.resize(182)
	chartArray1.fill(0)
	chartArray2.resize(182)
	chartArray2.fill(0)

func col(l):
	var col1 = Color(COLOR_ARRAY[0])
	var col2 = Color(COLOR_ARRAY[1])
	var col3 = Color(COLOR_ARRAY[2])
	if l >= 0 and l <= 0.5:
		return "[color=%s]" % [col1.lerp(col2, 2 * l).to_html()]
	else:
		return "[color=%s]" % [col2.lerp(col3, 2 * (l - 0.5)).to_html()]
	#return "[color=%s]" % [col1.lerp(col3,l).to_html()]

func textSet(arr):
	var text = ""
	var array = []
	array.resize(arr.size())
	array.fill(0)

	var max = 0
	var min = 0
	for i in array.size():
		if arr[i] >= max:
			max = arr[i]
		if arr[i] <= min:
			min = arr[i]
	if max == 0:
		max = 1

	for i in array.size():
		array[i] = (arr[i]-min)/(max-min)
		
	for i in 7:
		for j in 26:
				text = '%s%s.' % [text,col(array[(j*7)+i])]
		text = '%s%s' % [text,"\n"]
	
	return text

func updateLabels():
	chart_label_1.text = textSet(chartArray1)
	chart_label_2.text = textSet(chartArray2)
	chart_param_label.text = PARAM_NAMES[currentParam]
	chart_data_label.text = "(%s)" % [str(currentValue)]

func _ready():
	chartInit()

func getArray(arr,cP,yD):
	chartInit()
	currentParam = cP
	currentValue = arr[yD]
	
	for i in 182:
		chartArray1[i] = arr[i]
		chartArray2[i] = arr[i + 182]
	updateLabels()
