extends Label

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
var WORK_OUT_ARRAY = ["rest","pull","rest","push","pull","legs","push"]

@onready var DayLabel = get_node("/root/App/UI/DayLabel")

func _on_date_label_send_day(weekDay):
	DayLabel.text = '%s-%s' % [WEEK_NAME_ARRAY[weekDay],WORK_OUT_ARRAY[weekDay]] #mon-rest
