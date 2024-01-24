extends Label

var yearLine = "----------------------------------------------------"

func _receive_weekNum(wN):
	var year_line_label = get_node("/root/App/UI/year-line-label")
	yearLine[wN-1] = ">"
	year_line_label.text = yearLine

