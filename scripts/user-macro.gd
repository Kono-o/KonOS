extends Label

var yearDay = 0
func _receive_yearDay(yD):
	yearDay = yD
	readMacro()
	updateLabel()

var namePath = "user://name.txt"
var macroPath = "user://macro.txt"

const USER_PREFIX = "OS-user@"
const DEF_NAME = "default"
const YEAR_SIZE = 366
const MACRO_ARRAY_SIZE = (YEAR_SIZE*3)+3
const ARRAY_DELIMIT = ","

var username = DEF_NAME
var macroArray = []

@onready var user_macro_label = get_node("/root/App/UI/top-box/user-macro-label")

func writeName():
	FileAccess.open(namePath,FileAccess.WRITE).store_string(username)

func readName():
	if FileAccess.file_exists(namePath):
		username = FileAccess.open(namePath,FileAccess.READ).get_as_text()
		
	if !FileAccess.file_exists(namePath) or username == "":
		username = DEF_NAME
		writeName()

func writeMacro():
	FileAccess.open(macroPath,FileAccess.WRITE).store_csv_line(macroArray,ARRAY_DELIMIT)

func readMacro():
	macroArray.resize(MACRO_ARRAY_SIZE)
	if !FileAccess.file_exists(macroPath):
		for i in MACRO_ARRAY_SIZE:
			macroArray[i] = "0"
		writeMacro()
	else:
		macroArray = FileAccess.open(macroPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)

func updateLabel():
	user_macro_label.text ="%s%s\n%s%s\n%s%s%s\n%s%s%s" % [USER_PREFIX,username,"%% cals  ",macroArray[yearDay+YEAR_SIZE+YEAR_SIZE],"&& carb  ",macroArray[yearDay],"g","?? prot  ",macroArray[yearDay+YEAR_SIZE],"g"]

func _ready():
	readName()
	#readMacro() updateLabel() in _receive_yearDay(yD)
	

func _terminal_update_user(newName):
	username = newName
	writeName()
	updateLabel()

func _terminal_update_macro(type, amount):
	if type == "c":
		macroArray[yearDay] = str(int(macroArray[yearDay]) + amount)
	if(int(macroArray[yearDay])) < 0:
		macroArray[yearDay] = "0"
	if(int(macroArray[yearDay])) > 999:
		macroArray[yearDay] = "999"
	
	if type == "p":
		macroArray[yearDay+YEAR_SIZE] = str(int(macroArray[yearDay+YEAR_SIZE]) + amount)
	if(int(macroArray[yearDay+YEAR_SIZE])) < 0:
		macroArray[yearDay+YEAR_SIZE] = "0"
	if(int(macroArray[yearDay+YEAR_SIZE])) > 999:
		macroArray[yearDay+YEAR_SIZE] = "999"
	
	macroArray[yearDay+YEAR_SIZE+YEAR_SIZE] = str(4 * (int(macroArray[yearDay]) + int(macroArray[yearDay + YEAR_SIZE])))
	print (macroArray[yearDay+YEAR_SIZE+YEAR_SIZE])
	
	writeMacro()
	updateLabel()
