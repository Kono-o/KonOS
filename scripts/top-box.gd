extends Node2D

const infoPath = "user://info.txt"
const slotPath = "user://slot.txt"
const trackPath = "user://track.txt"
const habitPath = "user://habit.txt" 

@onready var unix_time_label = get_node("/root/App/UI/headers/unix-time-label")
@onready var user_macro_label = get_node("/root/App/UI/top-box/user-macro-label")
@onready var date_weight_label = get_node("/root/App/UI/top-box/date-weight-label")
@onready var year_line_label = get_node("/root/App/UI/top-box/year-line-label")

@onready var chart_label_1 = get_node("/root/App/UI/chart-box/chart-label-1")
@onready var chart_label_2 = get_node("/root/App/UI/chart-box/chart-label-2")
@onready var chart_line_label_1 = get_node("/root/App/UI/chart-box/chart-line-label-1")
@onready var chart_line_label_2 = get_node("/root/App/UI/chart-box/chart-line-label-2")

const MONTH_NAME_ARRAY = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

const WEEK_NAME_ARRAY = ["sun","mon","tue","wed","thu","fri","sat"]
const WORK_OUT_ARRAY = ["rest","push","pull","rest","push","pull","legs"]

const PARAM_NAMES = ["weight","calories","carbs","protien","fats"]

const ARRAY_DELIMIT = ","
const LINE_POINTER = "*"
const USER_PREFIX = "OS-user@"
const YEAR_SIZE = 366
const HABIT_LIMIT = 28
const CARB_OFFSET = YEAR_SIZE
const PROT_OFFSET = YEAR_SIZE*2
const FATS_OFFSET = YEAR_SIZE*3
const KCAL_OFFSET = YEAR_SIZE*4
const TRACK_SIZE =  YEAR_SIZE*5

const HABIT_SIZE =  YEAR_SIZE*HABIT_LIMIT

var swipeLength = 300
var startPos: Vector2
var swipeThreshold = 40
var swiping = false

var yearLine = "----------------------------------------------------"
var weekLine = "-------"

var username = "name"
var height = 0
var bfat = 0
var bmr = 0
var currentChart = 0
var currentCol = "bw"
var chartToggle = false
var infoArray = []
var slotNameArray = []

var weightArray = []
var carbArray =   []
var protArray =   []
var fatsArray =   []
var kcalArray =   []
var trackArray =  []

var habitArray =  []

var yearDay = 0

signal send_array(arr,cP,pN,yD,col)

func bmrCalc():
	var c1 = 0
	var c2 = 0
	var avgW = 0
	var avgK = 0
	var main = 0
	if(yearDay > 14):
		for i in 14:
			if weightArray[yearDay-1 - i] != 0 and weightArray[yearDay-2 - i] != 0:
				avgW += (weightArray[yearDay-2 - i]) - (weightArray[yearDay-1 - i])
				c1 += 1
			if kcalArray[yearDay-1 - i] != 0:
				avgK += kcalArray[yearDay-1 - i]
				c2 += 1
		if c1 != 0:
			avgW = (round((avgW/c1) * 100)/100.0) * 2.2
		if c2 != 0:
			avgK = round(avgK/c2)
	main = avgK + (avgW * 500)
	
	return macroCalc(main,1)
func macroCalc(g,ty):
	if ty == 1:
		if g > 9999:
			return "9999"
		if g > 999:
			return str(g)
		if g == 0:
			return "0000"
		if g > 0 and g < 10:
			return '000%s' % [g]
		if g > 9 and g < 100:
			return '00%s' % [g]
		if g > 99 and g < 1000:
			return '0%s' % [g]
		if g > 999 and g < 10000:
			return str(g)
	if ty == 0:
		if g <= 0:
			return "000"
		if g > 0 and g < 10:
			return '00%s' % [g]
		if g > 9 and g < 100:
			return '0%s' % [g]
		if g > 99 and g < 1000:
			return str(g)
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
		if feet > 9.9999:
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
func weightCalc(w):
	var trun = int(w)
	var cate = round((w - trun) * pow(10.0, 2)) / pow(10.0, 2) * 100
	var trunS = ''
	var cateS = ''
	
	if trun <= 0:
		trunS = "000"
	if trun < 10:
		trunS = '00%s' % [trun]
	if trun > 9 and trun < 100:
		trunS = '0%s' % [trun]
	if trun > 99 and trun < 1000:
		trunS = str(trun)
	if trun >= 999:
		trunS = "999"
	
	if cate <= 0:
		cateS = "00"
	if cate < 10:
		cateS = '0%s' % [cate]
	if cate > 9 and cate < 100:
		cateS = str(cate)
	if cate >= 99:
		cateS = "99"
	if trun > 999.99:
		cateS = "99"
		
	return '%s.%s' % [trunS, cateS]
func dateCalc(ty):
	var weekNum = '0'
	var dateTime = Time.get_datetime_dict_from_system()
	var month = MONTH_NAME_ARRAY[dateTime['month']-1];
	
	if yearDay == 0:
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

	var date = '%s-%s  w%s' % [dateStr,month,weekNum]
	var day = '%s-%s' % [WEEK_NAME_ARRAY[yearDay%7],WORK_OUT_ARRAY[yearDay%7]]
	
	if ty == 0:
		return date
	if ty == 1:
		return day

func writeInfo():
	infoArray[0] = username
	infoArray[1] = str(height)
	infoArray[2] = str(bfat)
	infoArray[3] = str(currentChart)
	infoArray[4] = currentCol

	FileAccess.open(infoPath,FileAccess.WRITE).store_csv_line(infoArray,ARRAY_DELIMIT)
	FileAccess.open(slotPath,FileAccess.WRITE).store_csv_line(slotNameArray,ARRAY_DELIMIT)
func readInfo():
	infoArray.resize(5)
	slotNameArray.resize(HABIT_LIMIT)
	
	if FileAccess.file_exists(infoPath):
		infoArray = FileAccess.open(infoPath,FileAccess.READ).get_csv_line()
		username = infoArray[0]
		height = float(infoArray[1])
		bfat = float(infoArray[2])
		currentChart = int(infoArray[3])
		currentCol = infoArray[4]

	if FileAccess.file_exists(slotPath):
		slotNameArray = FileAccess.open(slotPath,FileAccess.READ).get_csv_line()
	
	if !FileAccess.file_exists(slotPath) or !FileAccess.file_exists(infoPath):
		for i in HABIT_LIMIT:
			slotNameArray[i] = 'slot-%s' % [i+5]
		writeInfo()

func writeTrack():
	trackArray[yearDay-1] =           str(weightArray[yearDay-1])
	trackArray[yearDay-1+CARB_OFFSET] = str(carbArray[yearDay-1])
	trackArray[yearDay-1+PROT_OFFSET] = str(protArray[yearDay-1])
	trackArray[yearDay-1+FATS_OFFSET] = str(fatsArray[yearDay-1])
	trackArray[yearDay-1+KCAL_OFFSET] = str(kcalArray[yearDay-1])
	
	FileAccess.open(trackPath,FileAccess.WRITE).store_csv_line(trackArray,ARRAY_DELIMIT)
func readTrack():
	trackArray.resize(TRACK_SIZE)
	weightArray.resize(YEAR_SIZE)
	carbArray.resize(YEAR_SIZE)
	protArray.resize(YEAR_SIZE)
	fatsArray.resize(YEAR_SIZE)
	kcalArray.resize(YEAR_SIZE)
	
	if FileAccess.file_exists(trackPath):
		trackArray = FileAccess.open(trackPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)
		if trackArray.size() >= TRACK_SIZE:
			for i in YEAR_SIZE:
				weightArray[i] = float(trackArray[i])
				carbArray[i] = float(trackArray[i+CARB_OFFSET])
				protArray[i] = float(trackArray[i+PROT_OFFSET])
				fatsArray[i] = float(trackArray[i+FATS_OFFSET])
				kcalArray[i] = float(trackArray[i+KCAL_OFFSET])

	if !FileAccess.file_exists(trackPath):
		trackArray.fill("0")
		weightArray.fill(0)
		carbArray.fill(0)
		protArray.fill(0)
		fatsArray.fill(0)
		kcalArray.fill(0)
		writeTrack()

func writeHabit():
	FileAccess.open(habitPath,FileAccess.WRITE).store_csv_line(habitArray,ARRAY_DELIMIT)
func readHabit():
	habitArray.resize(HABIT_SIZE)
	habitArray.fill(0)
	if FileAccess.file_exists(habitPath):
		var habitFile = FileAccess.open(habitPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)
			
		for i in HABIT_SIZE:
			if habitFile.size() < HABIT_SIZE:
				habitArray[i] = 0
			else:
				habitArray[i] = float(habitFile[i])
	if !FileAccess.file_exists(habitPath):
		habitArray.fill(0)
		writeHabit()

func userMacroLabel():
	var nameLine = '%s%s'% [USER_PREFIX,username]
	var kcalLine = '%s-%s' % ['%% kcal',macroCalc(kcalArray[yearDay-1],1)]
	var carbLine = '%s-%sg' % ['&& carb',macroCalc(carbArray[yearDay-1],0)]
	var protLine = '%s-%sg' % ['?? prot',macroCalc(protArray[yearDay-1],0)]
	var fatsLine = '%s-%sg' % ['## fats',macroCalc(fatsArray[yearDay-1],0)]
	
	user_macro_label.text = '%s\n%s\n%s\n%s\n%s' % [nameLine,kcalLine,carbLine,protLine,fatsLine]
func dateWeightLabel():
	var dateLine = '%s/52' % [dateCalc(0)]
	var dayLine = '%s %s' %[dateCalc(1),weekLine]
	var heightLine = '%sʹ%sʺ %skg' %[heightCalc(0),heightCalc(1),weightCalc(weightArray[yearDay-1])]
	var bfLine = '%s%s-bf  %slm' % [bfatCalc(),'%',weightCalc(weightArray[yearDay-1]*(1 - (float(bfatCalc()) * 0.01)))]
	var bmrLine = '%smr' % [bmrCalc()]
	date_weight_label.text = '%s\n%s\n%s\n%s\n%s' % [dateLine,dayLine,heightLine,bfLine,bmrLine]
	bmrCalc()
	year_line_label.text = yearLine

func _ready():
	
	var rng = RandomNumberGenerator.new()
	var arrs = []
	arrs.resize(366)
	for i in arrs.size():
		arrs[i] = int(rng.randf_range(0,1000))
		if arrs[i] < 25:
			arrs[i] = 0
		if arrs[i] < 80:
			arrs[i] /= 2

	print(arrs)
	readInfo()
	readTrack()
	readHabit()
	dateWeightLabel()
	userMacroLabel()
	terminal_updateChart(currentChart)
func _process(_delta):
	
	unix_time_label.text = str(int(Time.get_unix_time_from_system()))
	
	if Input.is_action_just_pressed("touch"):
		if !swiping:
			swiping = true
			startPos = get_global_mouse_position()
	
	if Input.is_action_pressed("touch"):
		if swiping:
			var currentPos = get_global_mouse_position()
			if startPos.distance_to(currentPos) >= swipeLength:
				if abs(startPos.y-currentPos.y) <= swipeThreshold:
					if startPos.x < currentPos.x:
						change_habitSlot(0)
					if startPos.x > currentPos.x:
						change_habitSlot(1)
				if abs(startPos.x-currentPos.x) <= swipeThreshold:
						change_habitSlot(2)
				swiping = false

func terminal_updateUser(nN):
	username = nN.substr(0,14)
	writeInfo()
	userMacroLabel()
func terminal_updateHeight(nH):
	if nH > 0:
		height = round(nH * pow(10.0, 4)) / pow(10.0, 4)
	if nH > 3.05:
		height = 3.05
	writeInfo()
	dateWeightLabel()
func terminal_updateBF(nBF):
	if nBF > 0:
		bfat = round(nBF)
	if nBF > 99:
		bfat = 99
	writeInfo()
	dateWeightLabel()
func terminal_updateWeight(nW):
	if nW > 0:
		weightArray[yearDay-1] = round(nW * pow(10.0, 2)) / pow(10.0, 2)
	if nW > 999.99:
		weightArray[yearDay-1] = 999.99
	writeTrack()
	dateWeightLabel()
	terminal_updateChart(0)
func terminal_updateMacro(ty, amt):
	if ty == 'c':
		carbArray[yearDay-1] += amt
		if carbArray[yearDay-1] < 0:
			carbArray[yearDay-1] = 0
		if carbArray[yearDay-1] > 999:
			carbArray[yearDay-1] = 999
	if ty == 'p':
		protArray[yearDay-1] += amt
		if protArray[yearDay-1] < 0:
			protArray[yearDay-1] = 0
		if protArray[yearDay-1] > 999:
			protArray[yearDay-1] = 999
	if ty == 'f':
		fatsArray[yearDay-1] += amt
		if fatsArray[yearDay-1] < 0:
			fatsArray[yearDay-1] = 0
		if fatsArray[yearDay-1] > 999:
			fatsArray[yearDay-1] = 999
		
	kcalArray[yearDay-1] = 4 * (carbArray[yearDay-1] + protArray[yearDay-1])
	kcalArray[yearDay-1] += 9 * fatsArray[yearDay-1]
	kcalArray[yearDay-1] = round(kcalArray[yearDay-1]) # * 1.3
	if kcalArray[yearDay-1] > 9999:
		kcalArray[yearDay-1] = 9999
	writeTrack()
	userMacroLabel()
	terminal_updateChart(1)
func terminal_updateChart(cC):
	if cC == 0:
		send_array.emit(weightArray,0,PARAM_NAMES[0],yearDay-1,currentCol)
	if cC == 1:
		send_array.emit(kcalArray,1,PARAM_NAMES[1],yearDay-1,currentCol)
	if cC == 2:
		send_array.emit(carbArray,2,PARAM_NAMES[2],yearDay-1,currentCol)
	if cC == 3:
		send_array.emit(protArray,3,PARAM_NAMES[3],yearDay-1,currentCol)
	if cC == 4:
		send_array.emit(fatsArray,4,PARAM_NAMES[4],yearDay-1,currentCol)
	if cC > 4 and cC <= HABIT_LIMIT+4:
		send_array.emit(habitArray,cC,slotNameArray[cC-5],yearDay-1,currentCol)
	currentChart = cC
	writeInfo()
func terminal_updateColor(col):
	currentCol = col
	writeInfo()
	terminal_updateChart(currentChart)

func terminal_updateHabit(habit):
	habit = round(habit * 100) / 100
	if currentChart > 4:
		var curC = currentChart - 5
		habitArray[(yearDay-1) + (YEAR_SIZE * curC)] = habit
		writeHabit()
		terminal_updateChart(currentChart)
func change_habitSlot(lr):
	if lr == 0:
		if currentChart < HABIT_LIMIT+4:
			currentChart += 1
		elif currentChart == HABIT_LIMIT+4:
			currentChart = 0
	if lr == 1:
		if currentChart > 0:
			currentChart -= 1
		elif currentChart == 0:
			currentChart = HABIT_LIMIT+4
	if lr == 2:
		chartToggle = !chartToggle
		chart_label_1.visible = chartToggle
		chart_label_2.visible = chartToggle
		chart_line_label_1.visible = !chartToggle
		chart_line_label_2.visible = !chartToggle
	writeInfo()
	terminal_updateChart(currentChart)
func terminal_updateSlotName(sn):
	if currentChart > 4:
		slotNameArray[currentChart-5] = sn
		writeInfo()
		terminal_updateChart(currentChart)
	
func DEV_terminal_resetEverything():
	currentChart = 0
	DirAccess.remove_absolute(infoPath)
	DirAccess.remove_absolute(slotPath)
	DirAccess.remove_absolute(trackPath)
	DirAccess.remove_absolute(habitPath)
	readInfo()
	readTrack()
	readHabit()
	dateWeightLabel()
	userMacroLabel()
	terminal_updateChart(currentChart)

