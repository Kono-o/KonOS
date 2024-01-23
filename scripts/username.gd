extends Label

const DEF_NAME = "user"
var username = DEF_NAME
var filePath = "user://name.dat"

@onready var UsernameLabel = get_node("/root/App/UI/UsernameLabel")

func writeName(n):
	FileAccess.open(filePath,FileAccess.WRITE).store_string(n)

func readName():
	if FileAccess.file_exists(filePath):
		username = FileAccess.open(filePath,FileAccess.READ).get_as_text()
		
	if !FileAccess.file_exists(filePath) or username == "":
		username = DEF_NAME
		writeName(username)

func usernameSet(name):
	UsernameLabel.text = name
	writeName(name)

func _on_enter_button_update_name(newName):
	usernameSet(newName)
	
func _ready():
	readName()
	usernameSet(username)
