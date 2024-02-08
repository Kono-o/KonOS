extends LineEdit

@onready var terminal_line = get_node("/root/App/UI/terminal-line")

var nameFunctions = ["name","n","user","u"]
var heightFunctions = ["height","ht"]
var weightFunctions = ["kg","weight","w"]
var bfFunctions = ["bf","bfat","bodyfat"]

var macroFunctions = ["macro", "m"]
var kcalFunctions = ["k", "kcal","cal","cals","calo","calories"]
var carbFunctions = ["carb","carbs","c"]
var protFunctions = ["prot","pro","protien","protiens","p"]
var fatFunctions = ["fat","fats","f"]

var timerFunctions = ["timer","time","t"]
var startFunctions = ["start","s","go","g"]
var resetFunctions = ["reset","res","wipe","r"]
var pauseFunctions = ["pause","p"]

var chartFunctions = ["display","disp","d"]
var slotFunctions = ["slot","s"]
var renameFunctions = ["rename","r"]
var colorFunctions = ["color","col","colour"]
var habitFunctions = ["habit","hab","h"]
var yesFunctions = ["yes","y","true","1"]
var noFunctions = ["no","n","false","0"]
var flipFunctions = ["flip","fl","inv","invert"]

var devFunctions = ["dev","debug","deb"]

signal update_user(nN:String)
signal update_macro(ty:String,amt:int)
signal update_weight(nW:float)
signal update_height(nH:float)
signal update_bf(nBF:float)

signal update_chart(cC:int)
signal update_chartCol(col:String)
signal update_habit(habit:float)
signal update_slot_name(sn:String)
signal flip_chart()

signal update_timer(t:int)
signal start_timer()
signal pause_timer()
signal reset_timer()

signal dev_reset_everything()

func funcFinder(word,arr):
	for i in arr.size():
		if word.to_lower() == arr[i]:
			return true
func keywordEngine(command):
	var keywordArray = command.split(' ',false, 32)
	keywordArray.resize(32)

	if funcFinder(keywordArray[0],nameFunctions) and keywordArray[1] != "":
		update_user.emit(keywordArray[1])
	
	if funcFinder(keywordArray[0],heightFunctions):
		print(keywordArray[1])
		update_height.emit(float(keywordArray[1]))
		
	if funcFinder(keywordArray[0],bfFunctions):
		update_bf.emit(float(keywordArray[1]))
	
	if funcFinder(keywordArray[0],weightFunctions) and float(keywordArray[1]) != 0:
		update_weight.emit(float(keywordArray[1]))
	
	if funcFinder(keywordArray[0],carbFunctions) and int(keywordArray[1]) != 0:
		update_macro.emit("c",int(keywordArray[1]))
	if funcFinder(keywordArray[0],protFunctions) and int(keywordArray[1]) != 0:
		update_macro.emit("p",int(keywordArray[1]))
	if funcFinder(keywordArray[0],fatFunctions) and int(keywordArray[1]) != 0:
		update_macro.emit("f",int(keywordArray[1]))
	
	if funcFinder(keywordArray[0],timerFunctions) and int(keywordArray[1]) != 0:
		update_timer.emit(int(keywordArray[1]))
	if funcFinder(keywordArray[0],timerFunctions) and funcFinder(keywordArray[1],startFunctions):
		start_timer.emit()
	if funcFinder(keywordArray[0],timerFunctions) and funcFinder(keywordArray[1],pauseFunctions):
		pause_timer.emit()
	if funcFinder(keywordArray[0],timerFunctions) and funcFinder(keywordArray[1],resetFunctions):
		reset_timer.emit()
	
	if (funcFinder(keywordArray[0],chartFunctions) or funcFinder(keywordArray[0],slotFunctions)) and !funcFinder(keywordArray[1],renameFunctions):
		if funcFinder(keywordArray[1],weightFunctions) or int(keywordArray[1]) == 0:
			update_chart.emit(0)
		if funcFinder(keywordArray[1],kcalFunctions) or int(keywordArray[1]) == 1:
			update_chart.emit(1)
		if funcFinder(keywordArray[1],carbFunctions) or int(keywordArray[1]) == 2:
			update_chart.emit(2)
		if funcFinder(keywordArray[1],protFunctions) or int(keywordArray[1]) == 3:
			update_chart.emit(3)
		if funcFinder(keywordArray[1],fatFunctions) or int(keywordArray[1]) == 4:
			update_chart.emit(4)
		if int(keywordArray[1]) > 4:
			update_chart.emit(int(keywordArray[1]))
	if funcFinder(keywordArray[0],colorFunctions):
		update_chartCol.emit(keywordArray[1])
	
	if funcFinder(keywordArray[0],habitFunctions) and keywordArray[1] != '':
		if float(keywordArray[1]) <= 0 or funcFinder(keywordArray[1],noFunctions):
			update_habit.emit(0)
		if funcFinder(keywordArray[1],yesFunctions):
			update_habit.emit(1)
		if float(keywordArray[1]) > 9999.99:
			update_habit.emit(9999.99)
		if float(keywordArray[1]) > 0 and float(keywordArray[1]) <= 9999.99:
			var habitRounded = round(float(keywordArray[1])*100)/100
			update_habit.emit(habitRounded)
	
	if funcFinder(keywordArray[0],slotFunctions) and funcFinder(keywordArray[1],renameFunctions) and keywordArray[2] != '':
		update_slot_name.emit(keywordArray[2])
	if funcFinder(keywordArray[0],flipFunctions) and keywordArray[1] == "":
		flip_chart.emit()
	
	if funcFinder(keywordArray[0],devFunctions) and funcFinder(keywordArray[1],resetFunctions) and keywordArray[2] == "all":
		dev_reset_everything.emit()
		reset_timer.emit()

func _process(_delta):
	if Input.is_action_just_released("enter"):
		keywordEngine(terminal_line.text)
		terminal_line.text = ""

func timerButtonStart():
	start_timer.emit()
func timerButtonPause():
	pause_timer.emit()
func timerButtonReset():
	reset_timer.emit()
