extends Node2D

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")
@onready var chart_label_2 = get_node("/root/App/UI/chart-box/chart-label-2")

@onready var chart_param_label = get_node("/root/App/UI/chart-box/chart-param-label")
@onready var chart_data_label = get_node("/root/App/UI/chart-box/chart-data-label")

@onready var chart_line_label_1 = get_node("/root/App/UI/chart-box/chart-line-label-1")
@onready var chart_line_label_2 = get_node("/root/App/UI/chart-box/chart-line-label-2")

var square = preload("res://src/scenes/circle.tscn")
var flip = false
var wD = 0
var yeD = 0

const COL_DEF = "0F1116" #"0B0E18"
const COL_WHITE = ["1D212D","3D455F","8492C1","DBE2FF"]
const COL_RED = ["2D0B0D","5F0F16","C33D47","FFC1C3"]
const COL_YELLOW = ["372B00","725C00","E6BB00","FFFFC6"]
const COL_ORANGE = ["300E00","682800","D25700","FECEBE"]
const COL_PINK = ["2D0714","60002B","C22464","FEBBCC"]
const COL_GREEN = ["232D00","4D5F00","9FC100","E9FFB4"]
const COL_BLUE = ["12143B","1F205F","5153C2","C6C7FF"]
const COL_VIOLET = ["1D102D","3E1F5F","8751C2","DCC6FF"]

var colorArray = COL_BLUE

var pointArray1 = PackedVector2Array([Vector2(0, 0)])
var pointArray2 = PackedVector2Array([Vector2(0, 0)])
var chartArray = []
var avgArray = []

var currentParam = 0
var paramName = ""
var currentValue = 0

func chartInit():
	chartArray.resize(366)
	chartArray.fill(0)
	avgArray.resize(52)
	avgArray.fill(0)
	pointArray1.resize(26)
	pointArray2.resize(26)

func arrayNormalize(cArray):
	var array = []
	array.resize(cArray.size())
	array.fill(0)

	var max = 0
	var min = 9999999
	for i in cArray.size():
		if cArray[i] >= max:
			max = cArray[i]
		if cArray[i] <= min and cArray[i] > 0:
			min = cArray[i]
	if min == 9999999:
		min = 0
	for i in cArray.size():
		if (!min == 0 or !max == 0) and max != min:
			if cArray[i] != 0:
				array[i] = (cArray[i]-min)/(max-min) + 0.0001
			else:
				array[i] = 0
		if min == max and cArray[i] != 0:
			array[i] = 1

	return array
func normalize(min,max,n):
	return (n - min)/(max - min)
func lineLerp(pointArray,n):
	var max = 0
	var array = []
	var squareInstance
	
	for i in 52:
		var avg = 0
		for j in 7:
			avg = avg + chartArray[(7*i)+j]
		avgArray[i] = round(avg*100)/700
		avg = 0
		
	array.resize(avgArray.size())
	array.fill(0)
	if n:
		var squareChilds = chart_line_label_1.get_children()
		for i in squareChilds:
			chart_line_label_1.remove_child(i)
	if !n:
		var squareChilds = chart_line_label_2.get_children()
		for i in squareChilds:
			chart_line_label_2.remove_child(i)
	
	if currentParam == 0:
		array = arrayNormalize(avgArray)
	else:
		for  i in avgArray.size():
			if avgArray[i] > max:
				max = avgArray[i]
	
		for i in avgArray.size():
			if max == 0:
				array[i] = avgArray[i]
			else:
				array[i] = avgArray[i]/max
	
	for i in array.size():
		array[i] = round(array[i]*1000)/1000
	for i in array.size():
		if flip and i < wD:
			array[i] = 1 - array[i]
	
	for i in 26:
		squareInstance = square.instantiate()
		if n:
			pointArray[i] = Vector2(i*37,array[i] * -220)
		if !n:
			pointArray[i] = Vector2(i*37,array[i+26] * -220)
		
		squareInstance.position = pointArray[i]
		if n:
			chart_line_label_1.set_default_color(Color(colorArray[1]))
			chart_line_label_1.add_child(squareInstance)
		if !n:
			chart_line_label_2.set_default_color(Color(colorArray[1]))
			chart_line_label_2.add_child(squareInstance)
		
		squareInstance.get_node("square-label").label_settings.font_color = Color(colorArray[2])

	return pointArray
func colorLerp(l):
	var col0 = Color(COL_DEF)
	var col1 = Color(colorArray[0])
	var col2 = Color(colorArray[1])
	var col3 = Color(colorArray[2])
	var col4 = Color(colorArray[3])
	var finalCol = col0.to_html()
	if !flip:
		if l > 0 and l < 0.45:
			l = l + 0.25
			if l > 0.45:
				l = 0.45
			finalCol = col0.lerp(col1,normalize(0,0.45,l)).to_html()
		if l >= 0.45 and l < 0.75:
			finalCol = col1.lerp(col2,normalize(0.5,0.75,l)).to_html()
		if l >= 0.75 and l < 0.95:
			finalCol = col2.lerp(col3,normalize(0.75,0.95,l)).to_html()
		if l >= 0.95:
			finalCol = col3.lerp(col4,normalize(0.95,1,l)).to_html()
		return "[color=%s]" % [finalCol]
	if flip:
		if l > 0 and l < 0.45:
			finalCol = col4.to_html()
		if l >= 0.45 and l < 0.75:
			finalCol = col4.lerp(col3,normalize(0.45,0.75,l)).to_html()
		if l >= 0.75 and l < 0.95:
			finalCol = col3.lerp(col2,normalize(0.75,0.95,l)).to_html()
		if l >= 0.95:
			finalCol = col0.lerp(col1,normalize(0.5,0.75,l)).to_html()
		return "[color=%s]" % [finalCol]

func textSet(array,n):
	var text = ""
	for i in 7:
		for j in 26:
				text = '%s%s.' % [text,colorLerp(array[(j*7)+ i + (n * 182)])]
		text = '%s%s' % [text,"\n"]
	
	return text

func updateLabels():
	var textArray = arrayNormalize(chartArray)
	chart_label_1.text = textSet(textArray,0)
	chart_label_2.text = textSet(textArray,1)
	chart_param_label.text = paramName
	chart_data_label.text = "(%s)" % [str(currentValue)]

	chart_line_label_1.set_points(lineLerp(pointArray1,true))
	chart_line_label_2.set_points(lineLerp(pointArray2,false))

func _ready():
	chartInit()

func getArray(arr,cP,pN,yD,col):
	chartInit()
	wD = (yD+1)/7
	yeD = yD
	currentParam = cP
	paramName = pN
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
	
	for i in chartArray.size():
		if currentParam < 5:
			chartArray[i] = arr[i]
		else:
			chartArray[i] = arr[i + (366 * (currentParam-5))]
	
	currentValue = chartArray[yD]
	
	updateLabels()

func terminal_flipChart():
	flip = !flip
	updateLabels()
