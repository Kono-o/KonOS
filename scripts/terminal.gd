extends LineEdit

@onready var terminal_line = get_node("/root/App/UI/terminal-line")

var nameFunctions = ["name","n","user","u"]
var heightFunctions = ["height","h"]
var weightFunctions = ["kg","k","weight","w"]
var bfFunctions = ["bf","bfat","bodyfat"]

var macroFunctions = ["macro", "m"]
var carbFunctions = ["carb","carbs","c"]
var protFunctions = ["prot","protien","protiens","p"]
var fatFunctions = ["fat","fats","f"]
var timerFunctions = ["timer","time","t"]

var startFunctions = ["start","s"]


signal update_user(nN:String)
signal update_macro(ty:String,amt:int)
signal update_weight(nW:float)
signal update_height(nH:float)
signal update_bf(nBF:float)
signal update_timer(t:int)
signal start_timer()

func funcFinder(word,arr):
	for i in arr.size():
		if word == arr[i]:
			return true
	
func keywordEngine(command):
	var keywordArray = command.split(' ',false, 16)
	keywordArray.resize(16)

	if funcFinder(keywordArray[0],nameFunctions) and keywordArray[1] != "":
		update_user.emit(keywordArray[1])
	
	#if funcFinder(keywordArray[0],heightFunctions) and (int(keywordArray[1]) != 0 or int(keywordArray[2]) != 0):
		#update_height.emit(float(keywordArray[1]), float(keywordArray[2]))
	
	if funcFinder(keywordArray[0],heightFunctions):
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
	
func _process(_delta):
	if Input.is_action_just_released("enter"):
		keywordEngine(terminal_line.text)
		terminal_line.text = ""
