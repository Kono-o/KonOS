extends Label

var yearDay = 0
func _receive_yearDay(yD):
	yearDay = yD

var namePath = "user://name.txt"
var macroPath = "user://macro.txt"

const USER_PREFIX = "OS-user@"
const DEF_NAME = "default"
const MACRO_ARRAY_SIZE = 366
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

func writeMacro(arr):
	FileAccess.open(macroPath,FileAccess.WRITE).store_csv_line(arr,ARRAY_DELIMIT)

func readMacro():
	macroArray.resize(MACRO_ARRAY_SIZE)
	if !FileAccess.file_exists(macroPath):
		for i in MACRO_ARRAY_SIZE:
			macroArray[i] = 0
		writeMacro(macroArray)
	else:
		macroArray = FileAccess.open(macroPath,FileAccess.READ).get_csv_line(ARRAY_DELIMIT)

func updateLabel():
	user_macro_label.text ="%s%s\n%s%s" % [USER_PREFIX,username,"&& carb  ",macroArray[yearDay]]

func _ready():
	readName()
	readMacro()
	updateLabel()

func _terminal_update_user(newName):
	username = newName
	writeName()
	updateLabel()






