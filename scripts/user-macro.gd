extends Label

var yearDay = 0
func _receive_yearDay(yD):
	yearDay = yD-1
	readMacro()
	updateLabel()

var namePath = "user://name.txt"
var macroPath = "user://macro.txt"

const USER_PREFIX = "OS-user@"
const DEF_NAME = "default"

const YEAR_SIZE = 366
const CARB_SIZE = 0
const PROT_SIZE = YEAR_SIZE
const FATS_SIZE = 2*YEAR_SIZE
const KCAL_SIZE = 3*YEAR_SIZE
const MACRO_ARRAY_SIZE = 4*YEAR_SIZE

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
		macroArray.fill(0)
		writeMacro()
	else:
		macroArray = FileAccess.open(macroPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)

func updateLabel():
	var nameLine = '%s%s'     % [USER_PREFIX,username]
	var kcalLine = '%s  %s'   % ["%% kcal",macroArray[yearDay+KCAL_SIZE]]
	var carbLine = '%s  %s%s' % ["&& carb",macroArray[yearDay+CARB_SIZE],"g"]
	var protLine = '%s  %s%s' % ["?? prot",macroArray[yearDay+PROT_SIZE],"g"]
	var fatsLine = '%s  %s%s' % ["## fats",macroArray[yearDay+FATS_SIZE],"g"]
	
	user_macro_label.text ='%s\n%s\n%s\n%s\n%s' % [nameLine,kcalLine,carbLine,protLine,fatsLine]

func _ready():
	readName()
	#readMacro() updateLabel() in _receive_yearDay(yD)
	

func _terminal_update_user(newName):
	username = newName
	writeName()
	updateLabel()

func _terminal_update_macro(type, amount):
	if type == "c":
		macroArray[yearDay+CARB_SIZE] = str(int(macroArray[yearDay+CARB_SIZE]) + amount)
	if(int(macroArray[yearDay+CARB_SIZE])) < 0:
		macroArray[yearDay+CARB_SIZE] = "0"
	if(int(macroArray[yearDay+CARB_SIZE])) > 999:
		macroArray[yearDay+CARB_SIZE] = "999"
	
	if type == "p":
		macroArray[yearDay+PROT_SIZE] = str(int(macroArray[yearDay+PROT_SIZE]) + amount)
	if(int(macroArray[yearDay+PROT_SIZE])) < 0:
		macroArray[yearDay+PROT_SIZE] = "0"
	if(int(macroArray[yearDay+PROT_SIZE])) > 999:
		macroArray[yearDay+PROT_SIZE] = "999"
	
	if type == "f":
		macroArray[yearDay+FATS_SIZE] = str(int(macroArray[yearDay+FATS_SIZE]) + amount)
	if(int(macroArray[yearDay+FATS_SIZE])) < 0:
		macroArray[yearDay+FATS_SIZE] = "0"
	if(int(macroArray[yearDay+FATS_SIZE])) > 999:
		macroArray[yearDay+FATS_SIZE] = "999"
		
	var calCP = 4 * (int(macroArray[yearDay+CARB_SIZE]) + int(macroArray[yearDay+PROT_SIZE]))
	var calF = 9 * int(macroArray[yearDay+FATS_SIZE])
	macroArray[yearDay+KCAL_SIZE] = str(calCP+calF)
	
	writeMacro()
	updateLabel()
