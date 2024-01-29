extends Node2D

var infoPath = "user://info.txt"
var trackPath = "user://track.txt"

@onready var unix_time_label = get_node("/root/App/UI/headers/unix-time-label")
@onready var user_macro_label = get_node("/root/App/UI/top-box/user-macro-label")
@onready var date_weight_label = get_node("/root/App/UI/top-box/date-weight-label")
@onready var year_line_label = get_node("/root/App/UI/top-box/year-line-label")

const MONTH_NAME_ARRAY = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
const WORK_OUT_ARRAY = ["rest","push","pull","rest","push","pull","legs"]

const ARRAY_DELIMIT = ","
const LINE_POINTER = "*"
const USER_PREFIX = "OS-user@"

var yearLine = "----------------------------------------------------"
var weekLine = "-------"

var username = "default"
var height = 0
var bfat = 0
var infoArray = [username,str(height),str(bfat)]

func bfatCalc():
	if bfat > 99:
		return "99"
	if bfat <= 0:
		return "00"
	if bfat < 10:
		return '0%s' % [bfat]
	else:
		return str(bfat)
func heightCalc(ty):
	var feet = height * 3.28084
	var inch = 0.0
	
	if ty == 0:
		if feet > 9:
			return 9
		if feet < 0:
			return 0
		else:
			return int(feet)
			
	if ty == 1:
		if feet > 9.999:
			return "11.9"
		if feet < 0:
			return "00.0"
			
		inch = (feet - int(feet))* 12
		inch = round((inch * pow(10.0, 1))) / pow(10.0, 1)
		
		if(inch- int(inch)) == 0 and inch < 10:
			return '0%s.0' %[inch]
		if(inch- int(inch)) != 0 and inch < 10:
			return '0%s' %[inch]
		if(inch- int(inch)) == 0 and inch > 9:
			return '%s.0' %[inch]
		if(inch- int(inch)) != 0 and inch > 9:
			return str(inch)
func dateCalc(ty):
	var yearDay = 0
	var weekNum = '0'
	var dateTime = Time.get_datetime_dict_from_system()
	var month = MONTH_NAME_ARRAY[dateTime['month']-1];
	
	for i in dateTime['month']:
		yearDay += MONTH_DUR_ARRAY[i]
	yearDay += dateTime['day']
	
	if yearDay/7 < 10:
		weekNum = '0' + str(yearDay/7)
	else: 
		weekNum = str(yearDay/7)
		
	var dateNum = int(dateTime['day'])
	var dateStr = ""
	if dateNum < 10:
		dateStr = '%s%s' % ['0',str(dateNum)]
	else:
		dateStr = str(dateNum)
	
	if dateNum % 10 == 0 or dateNum % 10 > 3:
		dateStr = '%s%s' % [dateStr,"th"]
	if dateNum % 10 == 1:
		dateStr = '%s%s' % [dateStr,"st"]
	if dateNum % 10 == 2:
		dateStr = '%s%s' % [dateStr,"nd"]
	if dateNum % 10 == 3:
		dateStr = '%s%s' % [dateStr,"rd"]

	yearLine[int(weekNum)-1] = LINE_POINTER
	if(yearDay%7 == 0):
		weekLine[6] = LINE_POINTER
	else:
		weekLine[int(yearDay%7)-1] = LINE_POINTER
		
	var date = '%s-%s  %s%s%s' % [dateStr,month,'w', weekNum, '/52']
	var day = '%s-%s' % [WEEK_NAME_ARRAY[yearDay%7],WORK_OUT_ARRAY[yearDay%7]]
	
	if ty == 0:
		return date
	if ty == 1:
		return day

func writeInfo():
	infoArray = [username,str(height),str(bfat)]
	FileAccess.open(infoPath,FileAccess.WRITE).store_csv_line(infoArray,ARRAY_DELIMIT)
func readInfo():
	if FileAccess.file_exists(infoPath):
		var infoFile = FileAccess.open(infoPath,FileAccess.READ).get_csv_line()
		username = infoFile[0]
		height = float(infoFile[1])
		bfat = float(infoFile[2])
		
	if !FileAccess.file_exists(infoPath):
		writeInfo()

func userMacroLabel():
	var nameLine = '%s%s'% [USER_PREFIX,username]
	user_macro_label.text = '%s' % [nameLine]
func dateWeightLabel():
	var dateLine = dateCalc(0)
	var dayLine = '%s %s' %[dateCalc(1),weekLine]
	var heightLine = '%sB%sA' %[heightCalc(0),heightCalc(1)]
	var bfLine = '%s%s-bf' % [bfatCalc(),'%']
	
	date_weight_label.text = '%s\n%s\n%s\n%s' % [dateLine,dayLine,heightLine,bfLine]
	year_line_label.text = yearLine
	
func _ready():
	readInfo()
	userMacroLabel()
	dateWeightLabel()
func _process(_delta):
	unix_time_label.text = str(int(Time.get_unix_time_from_system()))

func terminal_updateUser(nN):
	username = nN.substr(0,14)
	writeInfo()
	userMacroLabel()
func terminal_updateHeight(nH):
	height = nH
	writeInfo()
	dateWeightLabel()
func terminal_updateBF(nBF):
	bfat = round(nBF)
	writeInfo()
	dateWeightLabel()
