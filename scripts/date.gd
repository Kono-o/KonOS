extends Label

const MONTH_NAME_ARRAY = ["nul","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

var month = MONTH_NAME_ARRAY[0];
var yearDay = 0;
var weekNum = '0';

@onready var DateLabel = get_node("/root/App/UI/DateLabel")

signal send_day(weekDay:int)

func dateConcat():
	
	var dateTime = Time.get_datetime_dict_from_system() #YYYY-MM-DD in numbers
	month = MONTH_NAME_ARRAY[dateTime['month']]; #month number
	
	for i in dateTime['month']: #which day of the year
		yearDay += MONTH_DUR_ARRAY[i]
	
	yearDay += dateTime['day'] #which day of the year + incomplete month's days
	if yearDay/7 < 10:
		weekNum = '0' + str(yearDay/7)
	else: 
		weekNum = str(yearDay/7)
	
	var date = '%s-%s %s%s%s' % [dateTime['day'],month,'w', weekNum, '/52'] #final concat
	
	send_day.emit(yearDay%7) #sending day of the week to day.gd
	
	return str(date) 

func dateSet():
	DateLabel.text = dateConcat()
	
func _ready():
	dateSet()

