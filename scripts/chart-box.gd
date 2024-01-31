extends Node2D

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")

const COLOR_ARRAY = ["#ffffff","#4a4a4a"]

var color_array = []

func strToCol():
	color_array.resize(COLOR_ARRAY.size())
	for i in COLOR_ARRAY.size():
		color_array[i] = Color(COLOR_ARRAY[i]).to_html()
func col(c):
	return "[color=%s]" % [color_array[c]]

func _ready():
	strToCol()
	var text = ""
	var tog = 0
	for i in 182:
		if i % 2 == 0:
			text = '%s%s.' % [text,col(tog)]
		if i % 2 == 1:
			text = '%s%s.' % [text,col(abs(1-tog))]
		if i % 26 == 25 and i != 0:
			text = '%s\n' % [text]
			tog = abs(1-tog)
	
	chart_label_1.text = text
func _process(delta):
	pass
