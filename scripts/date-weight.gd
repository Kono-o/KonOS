extends Label

const MONTH_NAME_ARRAY = ["nul","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
var WORK_OUT_ARRAY = ["rest","push","pull","rest","push","pull","legs"]

var date = null
var day = null

@onready var date_weight_label = get_node("/root/App/UI/top-box/date-weight-label")

func dateCalc():
	var yearDay = 0
	var weekNum = '0'
	var dateTime = Time.get_datetime_dict_from_system() #YYYY-MM-DD in numbers
	var month = MONTH_NAME_ARRAY[dateTime['month']]; #month number
	
	for i in dateTime['month']: #which day of the year
		yearDay += MONTH_DUR_ARRAY[i]
	
	yearDay += dateTime['day'] #which day of the year + incomplete month's days
	if yearDay/7 < 10:
		weekNum = '0' + str(yearDay/7)
	else: 
		weekNum = str(yearDay/7)
	
	date = '%s-%s %s%s%s' % [dateTime['day'],month,'w', weekNum, '/52'] #final concat
	day = '%s-%s' % [WEEK_NAME_ARRAY[yearDay%7],WORK_OUT_ARRAY[yearDay%7]] #mon-push
	
func dateConcat():
	dateCalc()
	var concat = '%s\n%s\n%s\n%s' % [date,"place","holder",day]
	return str(concat) 

func _ready():
	date_weight_label.text = dateConcat()

