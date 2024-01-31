extends Node2D

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")

#const COLOR_ARRAY = ["#fcba03","#0373fc"]
const COLOR_ARRAY = ["#ffffff","#000000"]

var color_array = []

func strToCol():
	color_array.resize(COLOR_ARRAY.size())
	for i in COLOR_ARRAY.size():
		color_array[i] = Color(COLOR_ARRAY[i]).to_html()
func col(l):
	var col1 = Color(COLOR_ARRAY[0])
	var col2 = Color(COLOR_ARRAY[1])
	return "[color=%s]" % [col1.lerp(col2,l).to_html()]

func textSet(arr):
	var text = ""
	var array = []
	array.resize(arr.size())
	
	var max = 0.0
	var min = 0.0
	for i in arr.size():
		if arr[i] > max:
			max = arr[i]
		if arr[i] < min:
			min = arr[i]
	
	for i in array.size():
		array[i] = (arr[i]-min)/(max-min)
	
	for i in 7:
		for j in 26:
				text = '%s%s.' % [text,col(array[(j*7)+i])]
		text = '%s%s' % [text,"\n"]
	
	return text
	
func _ready():
	pass
	
func _process(delta):
	var rng = RandomNumberGenerator.new()
	rng.seed = int(Time.get_unix_time_from_system())
	strToCol()
	
	var arry = []
	arry.resize(182)
	for i in 182:
		arry[i] = rng.randf_range(0, 181)
	
	chart_label_1.text = textSet(arry)
