extends Label

var weightPath = "user://weight.txt"
var heightPath = "user://height.txt"

const MONTH_NAME_ARRAY = ["nul","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
var WORK_OUT_ARRAY = ["rest","push","pull","rest","push","pull","legs"]

const WEIGHT_ARRAY_SIZE = 366
const ARRAY_DELIMIT = ","

var weightArray = []
var date = null
var day = null
var height = 0.0
var bmr = null
var bmi = null

var yearDay = 0
signal send_yearDay(yD:int)
signal send_weekNum(wN:int)

@onready var date_weight_label = get_node("/root/App/UI/top-box/date-weight-label")

func kgToLbs(kg): 
	var lb = int(float(kg) * 2.2)
	var bs = round(((float(kg) * 2.2) - lb) * pow(10.0, 2)) / pow(10.0, 2)
	var lbs = str(lb)
	if str(lb).length() == 1:
		lbs = '%s%s' % ["00",str(lb)]
	if str(lb).length() == 2:
		lbs = '%s%s' % ["0",str(lb)]
	
	if(str(bs).length() == 1):
		lbs = '%s.%s' % [lbs,"00"]
	if(str(bs).length() == 3):
		lbs = '%s.%s%s' % [lbs,str(bs)[2],"0"]
	if(str(bs).length() == 4):
		lbs = '%s.%s%s' % [lbs,str(bs)[2],str(bs)[3]]
	if float(kg) > 454:
		lbs = "998.80"
	return lbs

func writeHeight():
	FileAccess.open(heightPath,FileAccess.WRITE).store_float(height)

func readHeight():
	if FileAccess.file_exists(heightPath):
		height = FileAccess.open(heightPath,FileAccess.READ).get_float()
		
	if !FileAccess.file_exists(heightPath) or height == 0.0:
		height = 0.0
		writeHeight()
		
func writeWeight():
	FileAccess.open(weightPath,FileAccess.WRITE).store_csv_line(weightArray,ARRAY_DELIMIT)

func readWeight():
	weightArray.resize(WEIGHT_ARRAY_SIZE)
	if !FileAccess.file_exists(weightPath):
		for i in WEIGHT_ARRAY_SIZE:
			weightArray[i] = "00.00"
		writeWeight()
	else:
		weightArray = FileAccess.open(weightPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)

func dateCalc():
	var weekNum = '0'
	var dateTime = Time.get_datetime_dict_from_system() #YYYY-MM-DD in numbers
	var month = MONTH_NAME_ARRAY[dateTime['month']]; #month number
	
	for i in dateTime['month']: #which day of the year
		yearDay += MONTH_DUR_ARRAY[i]
	
	yearDay += dateTime['day'] #which day of the year + incomplete month's days
	
	send_yearDay.emit(yearDay)#send yearDay to user-macro
	
	if yearDay/7 < 10:
		weekNum = '0' + str(yearDay/7)
	else: 
		weekNum = str(yearDay/7)
	
	send_weekNum.emit(int(weekNum))#send weekNum to year-line
	
	date = '%s-%s   %s%s%s' % [dateTime['day'],month,'w', weekNum, '/52']  #23-jan   w03/52
	day = '%s-%s' % [WEEK_NAME_ARRAY[yearDay%7],WORK_OUT_ARRAY[yearDay%7]] #mon-push

func updateLabel():
	var heightLine = '%s%s' % [str(height),"cm"]
	date_weight_label.text = '%s\n%s\n%s' % [date,day,height]

func _terminal_updateWeight(newWeight):
	weightArray[yearDay] = str(newWeight)
	if str(int(weightArray[yearDay])).length() == 3:
		weightArray[yearDay] = '%s.%s' % [weightArray[yearDay],"0"]
	if weightArray[yearDay].length() == 4:
		weightArray[yearDay] = '%s%s' % [weightArray[yearDay],"0"]
	if weightArray[yearDay].length() == 2:
		weightArray[yearDay] = '%s.%s' % [weightArray[yearDay],"00"]
	if weightArray[yearDay].length() == 1:
		weightArray[yearDay] = '%s%s.%s' % ["0",weightArray[yearDay],"00"]
	if float(weightArray[yearDay]) > 454:
		weightArray[yearDay] = "454.0"
	if float(weightArray[yearDay]) < 0:
		weightArray[yearDay] = "00.00"
	writeWeight()
	updateLabel()

func _ready():
	dateCalc()
	readWeight()
	readHeight()
	updateLabel()


func _terminal_updateHeight(newFeet, newInch):
	print(height)
