extends Node2D

var infoPath = "user://info.txt"
var trackPath = "user://track.txt"

@onready var unix_time_label = get_node("/root/App/UI/headers/unix-time-label")
@onready var user_macro_label = get_node("/root/App/UI/top-box/user-macro-label")
@onready var date_weight_label = get_node("/root/App/UI/top-box/date-weight-label")
@onready var year_line_label = get_node("/root/App/UI/top-box/year-line-label")

const MONTH_NAME_ARRAY = ["nul","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
const WORK_OUT_ARRAY = ["rest","push","pull","rest","push","pull","legs"]

const ARRAY_DELIMIT = ","
const USER_PREFIX = "OS-user@"

var yearLine = "----------------------------------------------------"

var username = "user"
var height = 0.0
var bfat = 0
var infoArray = [username,str(height),str(bfat)]
var date = null
var day = null

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
		
	date = '%s-%s    %s%s%s' % [dateTime['day'],month,'w', weekNum, '/52']  #23-jan   w03/52
	day = '%s-%s' % [WEEK_NAME_ARRAY[yearDay%7],WORK_OUT_ARRAY[yearDay%7]] #mon-push
	
	yearLine[int(weekNum)-1] = ">"
func writeInfo():
	FileAccess.open(infoPath,FileAccess.WRITE).store_csv_line(infoArray,ARRAY_DELIMIT)
func readInfo():
	if FileAccess.file_exists(infoPath):
		var infoFile = FileAccess.open(infoPath,FileAccess.READ).get_csv_line()
		username = infoFile[0]
		height = infoFile[1]
		bfat = infoFile[2]
		
	if !FileAccess.file_exists(infoPath):
		writeInfo()
func userMacro():
	var nameLine = '%s%s'% [USER_PREFIX,username]
	user_macro_label.text = '%s' % [nameLine]
func dateWeight():
	dateCalc()
	date_weight_label.text = '%s\n%s' % [date,day]
	year_line_label.text = yearLine
	
func _ready():
	readInfo()
	dateWeight()
	
func _process(_delta):
	unix_time_label.text = str(int(Time.get_unix_time_from_system()))


