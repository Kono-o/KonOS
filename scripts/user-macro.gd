extends Label

const USER_PREFIX = "OS-user@"
const DEF_NAME = "default"

var username = DEF_NAME
var filePath = "user://name.dat"

@onready var user_macro_label = get_node("/root/App/UI/top-box/user-macro-label")

func writeName(n):
	FileAccess.open(filePath,FileAccess.WRITE).store_string(n)

func readName():
	if FileAccess.file_exists(filePath):
		username = FileAccess.open(filePath,FileAccess.READ).get_as_text()
		
	if !FileAccess.file_exists(filePath) or username == "":
		username = DEF_NAME
		writeName(username)

func usernameSet(n):
	user_macro_label.text ="%s%s" % [USER_PREFIX,n]
	writeName(n)

func _ready():
	readName()
	usernameSet(username)

func _terminal_update_user(newName):
	usernameSet(newName)
